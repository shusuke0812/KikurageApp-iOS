//
//  KikurageQRCodeReaderViewModel.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/7/15.
//  Copyright © 2022 shusuke. All rights reserved.
//

// Ref: https://developer.apple.com/documentation/avfoundation/capture_setup/avcam_building_a_camera_app

import Foundation
import AVFoundation

public enum SessionSetupResult {
    case success
    case error(SessionSetupError)
}

public enum SessionSetupError {
    case failure
    case notAuthorized
}

protocol KikurageQRCodeReaderViewModelDelegate: AnyObject {
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModelDelegate, didConfigured captureSession: AVCaptureSession)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModelDelegate, didFailedConfigured captureSession: AVCaptureSession, error: SessionSetupError)
}

public class KikurageQRCodeReaderViewModel: NSObject {
    private var captureSessionQueue = DispatchQueue(label: (Bundle.main.bundleIdentifier ?? "missing_bundle_id") + "_capture.session")

    // MARK: Event notification

    weak var delegate: KikurageQRCodeReaderViewModelDelegate?
    var readQRCodeString: ((String) -> Void)?

    // MARK: AVCapture

    private var setupResult: SessionSetupResult = .success

    private let captureSession = AVCaptureSession()
    @objc private dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private var metadataOutput = AVCaptureMetadataOutput()

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        captureSessionQueue.async {
            self.configureSession(onError: { error in
                print("faile:\(error?.localizedDescription)")
            })
        }
    }

    /**
    setup capture session

    It's not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
     
    Don't perform these tasks on the main queue because
    AVCaptureSession.startRunning() is a blocking call, which can take a long time.
    Dispatch session setup to the sessionQueue, so that the main queue isn't blocked, which keeps the UI responsive.
    */
    func configureSession(onError: ((Error?) -> Void)) {
        if setupResult != .success { return }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo // do not create an AVCaptureMovieFileOutput when setting up the session because of not supported.

        // add video input
        do {
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                setupResult = .failure
                captureSession.commitConfiguration()
                onError(nil)
                return
            }
            let videDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videDeviceInput) {
                captureSession.addInput(videDeviceInput)
                videoDeviceInput = videDeviceInput
            } else {
                onError(nil)
            }
        } catch {
            setupResult = .failure
            captureSession.commitConfiguration()
            onError(error)
        }

        // add video output
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: captureSessionQueue)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            onError(nil)
        }

        captureSession.commitConfiguration()
    }
    /**
    discover camera inputs which is possible to setup capture session
    */
    func discoverDeviceCamera() -> AVCaptureDeviceInput? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        let devices = discoverySession.devices
        if let backCamera = devices.first {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                return deviceInput
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension KikurageQRCodeReaderViewModel: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] { // swiftlint:disable:this force_cast
            guard let value = metadata.stringValue else {
                return
            }
            captureSession.stopRunning()
            readQRCodeString?(value)
        }
    }
}
