//
//  KikurageQRCodeReaderView.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/2/4.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import AVFoundation

public class KikurageQRCodeReaderView: UIView {

    public var readQRcodeString: ((String) -> Void)?
    
    private let session = AVCaptureSession()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initDeviceCamera()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}

// MARK: - Initialize

extension KikurageQRCodeReaderView {
    private func initDeviceCamera() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        let devices = discoverySession.devices
        if let backCamera = devices.first {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                initiate(deviceInput: deviceInput)
            } catch {
                print("Error while creating video device input : \(error)")
            }
        }
    }
    private func initiate(deviceInput: AVCaptureDeviceInput) {
        if session.canAddInput(deviceInput) { return }
        session.addInput(deviceInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if !session.canAddOutput(metadataOutput) { return }
        session.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }
}

// MARK: - Session

extension KikurageQRCodeReaderView {
    public func startRunning() {
        session.startRunning()
    }
}

// MARK: - AVCaptureMetadataOutputObjects Delegate

extension KikurageQRCodeReaderView: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            guard let value = metadata.stringValue else { return }
            
            session.stopRunning()
            readQRcodeString?(value)
        }
    }
}
