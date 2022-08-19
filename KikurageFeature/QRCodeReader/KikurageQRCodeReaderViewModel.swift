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
import UIKit

public protocol KikurageQRCodeReaderViewModelDelegate: AnyObject {
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didConfigured captureSession: AVCaptureSession)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didFailedConfigured captureSession: AVCaptureSession, error: SessionSetupError)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didRead qrCodeString: String)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, didNotRead error: SessionSetupError)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, authorize: SessionSetupResult)
}

public class KikurageQRCodeReaderViewModel: NSObject {
    private let captureSessionQueue = DispatchQueue(label: (Bundle.main.bundleIdentifier ?? "missing_bundle_id") + "_capture.session")

    // MARK: - Event notification

    public weak var delegate: KikurageQRCodeReaderViewModelDelegate?

    // MARK: - AVCapture

    private var setupResult: SessionSetupResult = .success

    public var captureSession: AVCaptureSession!
    @objc private dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private var metadataOutput: AVCaptureMetadataOutput

    override public init() {
        self.captureSession = AVCaptureSession()
        self.metadataOutput = AVCaptureMetadataOutput()
        super.init()

        setup()
    }

    private func setup() {
        // If it is required authorization, remove comment outs.
        // authorize()
        captureSessionQueue.async {
            self.configureSession()
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
    private func configureSession() {
        if setupResult != .success { return }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo // do not create an AVCaptureMovieFileOutput when setting up the session because of not supported.

        // add video input
        do {
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                setupResult = .error(.failure)
                captureSession.commitConfiguration()
                delegate?.qrCodeReaderViewModel(self, didFailedConfigured: self.captureSession, error: .failure)
                return
            }
            let videDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videDeviceInput) {
                captureSession.addInput(videDeviceInput)
                videoDeviceInput = videDeviceInput
            } else {
                captureSession.commitConfiguration()
                delegate?.qrCodeReaderViewModel(self, didFailedConfigured: self.captureSession, error: .failure)
                return
            }
        } catch {
            setupResult = .error(.failure)
            captureSession.commitConfiguration()
            delegate?.qrCodeReaderViewModel(self, didFailedConfigured: self.captureSession, error: .failure)
            return
        }

        // add video output
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: captureSessionQueue)
            metadataOutput.metadataObjectTypes = [.qr]
            captureSession.commitConfiguration()
            delegate?.qrCodeReaderViewModel(self, didConfigured: captureSession)
        } else {
            captureSession.commitConfiguration()
            delegate?.qrCodeReaderViewModel(self, didFailedConfigured: self.captureSession, error: .failure)
        }
    }

    /**
    check video authorization

    this method must run before `configureSession()`
    */
    private func authorize() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            delegate?.qrCodeReaderViewModel(self, authorize: setupResult)
        case .notDetermined:
            captureSessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                guard let self = self else { return }
                if !granted {
                    self.setupResult = .error(.notAuthorized)
                }
                self.delegate?.qrCodeReaderViewModel(self, authorize: self.setupResult)
                self.captureSessionQueue.resume()
            })
        default:
            setupResult = .error(.notAuthorized)
            delegate?.qrCodeReaderViewModel(self, authorize: setupResult)
        }
    }
    /*
    validate QRCode string
     
    If QRCode string is contained `http` or `https`, application crush when read QRCode
    */
    private func validate(for qrCodeString: String) -> Bool {
        if qrCodeString.contains("http://") || qrCodeString.contains("https://") {
            return false
        } else {
            return true
        }
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
        captureSessionQueue.async {
            guard !self.captureSession.isRunning else { return }
            self.captureSession.startRunning()
        }
    }
    public func stopRunning() {
        captureSessionQueue.async {
            guard !self.captureSession.isRunning else { return }
            self.captureSession.stopRunning()
        }
    }
    public func removeCaptureSession() {
        stopRunning()
        captureSession.outputs.forEach { captureSession.removeOutput($0) }
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession = nil
    }
}

// MARK: - AVCaptureMetadataOutputObjects Delegate

extension KikurageQRCodeReaderViewModel: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] { // swiftlint:disable:this force_cast
            guard let value = metadata.stringValue else {
                return
            }
            captureSession.stopRunning()
            if validate(for: value) {
                delegate?.qrCodeReaderViewModel(self, didRead: value)
            } else {
                delegate?.qrCodeReaderViewModel(self, didNotRead: .notReadQRCode)
            }
        }
    }
}
