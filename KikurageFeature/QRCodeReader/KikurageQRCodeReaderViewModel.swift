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
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, interrupted reason: AVCaptureSession.InterruptionReason)
    func qrCodeReaderViewModel(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModel, interruptionEnded captureSession: AVCaptureSession)
}

public class KikurageQRCodeReaderViewModel: NSObject {
    private let captureSessionQueue = DispatchQueue(label: (Bundle.main.bundleIdentifier ?? "missing_bundle_id") + "_capture.session")
    private var isCaptureSessionRunning = false
    private var kvos = [NSKeyValueObservation]()

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
            var defaultVideoDevice: AVCaptureDevice?
            if let dualVideoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualVideoDevice
            } else if let dualWideCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = dualWideCameraDevice
            }
            guard let videoDevice = defaultVideoDevice else {
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
        // add an audio input for video
        /*
        do {
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if captureSession.canAddInput(audioDeviceInput) {
                captureSession.addInput(audioDeviceInput)
            } else {
                delegate?.qrCodeReaderViewModel(self, didFailedConfigured: self.captureSession, error: .failure)
            }
        } catch {
            delegate?.qrCodeReaderViewModel(self, didFailedConfigured: self.captureSession, error: .failure)
        }
        */

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
    /**
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
    /**
     observers for AVCaptureSession running
     */
    private func addObservers() {
        let kvo = captureSession.observe(\.isRunning, options: .new) { _, change in
            guard let isCaptureSessionRunning = change.newValue else { return }
            // If session running changes something, write here
        }
        kvos.append(kvo)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionRuntimeError), name: .AVCaptureSessionRuntimeError, object: videoDeviceInput.device)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionWasInterrupted), name: .AVCaptureSessionWasInterrupted, object: captureSession)
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionEnded), name: .AVCaptureSessionInterruptionEnded, object: captureSession)
    }
    
    // MARK: - Error
    
    @objc private func sessionRuntimeError(notification: Notification) {
        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else { return }
        if error.code == .mediaServicesWereReset {
            captureSessionQueue.async {
                if self.isCaptureSessionRunning {
                    self.captureSession.isRunning
                    self.isCaptureSessionRunning = self.captureSession.isRunning
                }
            }
        }
    }
    
    @objc private func sessionWasInterrupted(notification: Notification) {
        if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject,
           let reasonIntValue = userInfoValue.integerValue,
           let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntValue) {
            delegate?.qrCodeReaderViewModel(self, interrupted: reason)
        }
    }
    
    @objc private func sessionInterruptionEnded(notification: Notification) {
        delegate?.qrCodeReaderViewModel(self, interruptionEnded: self.captureSession)
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
    /**
     start capturing on initialization. If restart, it has to use `resume()` method.
     */
    public func startRunning() {
        captureSessionQueue.async {
            guard !self.captureSession.isRunning else { return }
            self.captureSession.startRunning()
            self.isCaptureSessionRunning = self.captureSession.isRunning
        }
    }
    public func stopRunning() {
        captureSessionQueue.async {
            guard !self.captureSession.isRunning else { return }
            self.captureSession.stopRunning()
            self.isCaptureSessionRunning = self.captureSession.isRunning
        }
    }
    /**
     restart capturing on error. For example, it uses this method when session is interrupted.
     */
    public func resume() {
        captureSessionQueue.async {
            self.captureSession.startRunning()
            self.isCaptureSessionRunning = self.captureSession.isRunning
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
