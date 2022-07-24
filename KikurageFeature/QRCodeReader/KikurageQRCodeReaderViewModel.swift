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

public protocol KikurageQRCodeReaderViewModelDelegate: AnyObject {
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didConfigured captureSession: AVCaptureSession)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didFailedConfigured captureSession: AVCaptureSession, error: SessionSetupError)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didRead qrCodeString: String)
}

public class KikurageQRCodeReaderViewModel: NSObject {
    private var captureSessionQueue = DispatchQueue(label: (Bundle.main.bundleIdentifier ?? "missing_bundle_id") + "_capture.session")

    // MARK: - Event notification

    public weak var delegate: KikurageQRCodeReaderViewModelDelegate?

    // MARK: - AVCapture

    private var setupResult: SessionSetupResult = .success

    public let captureSession: AVCaptureSession
    @objc private dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private var metadataOutput: AVCaptureMetadataOutput

    public override init() {
        self.captureSession = AVCaptureSession()
        self.metadataOutput = AVCaptureMetadataOutput()
        super.init()

        setup()
    }

    private func setup() {
        captureSessionQueue.async {
            self.configureSession(onError: { [weak self] error in
                guard let self = self, let error = error else { return }
                self.delegate?.qrCodeReaderViewModel(self, didFailedConfigured: self.captureSession, error: error)
            })
        }
    }
    
    // MARK: - Private

    /**
    setup capture session

    It's not safe to mutate an AVCaptureSession or any of its inputs, outputs, or connections from multiple threads at the same time.
     
    Don't perform these tasks on the main queue because
    AVCaptureSession.startRunning() is a blocking call, which can take a long time.
    Dispatch session setup to the sessionQueue, so that the main queue isn't blocked, which keeps the UI responsive.
    */
    private func configureSession(onError: ((SessionSetupError?) -> Void)) {
        if setupResult != .success { return }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo // do not create an AVCaptureMovieFileOutput when setting up the session because of not supported.

        // add video input
        do {
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                setupResult = .error(.failure)
                captureSession.commitConfiguration()
                onError(.failure)
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
            setupResult = .error(.failure)
            captureSession.commitConfiguration()
            onError(.failure)
        }

        // add video output
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: captureSessionQueue)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            onError(.failure)
        }

        captureSession.commitConfiguration()
    }
    private func authorize() {
        // TODO: add camera authorize checking
    }
    
    // MARK: - Public

    /**
    discover camera inputs which is possible to setup capture session
    */
    public func discoverDeviceCamera() -> AVCaptureDeviceInput? {
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
    public func startRunning() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    public func stopRunning() {
        guard !captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
}

extension KikurageQRCodeReaderViewModel: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] { // swiftlint:disable:this force_cast
            guard let value = metadata.stringValue else {
                return
            }
            captureSession.stopRunning()
            delegate?.qrCodeReaderViewModel(self, didRead: value)
        }
    }
}
