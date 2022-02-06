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
    
    private let captureSession = AVCaptureSession()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initDeviceCamera()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDeviceCamera()
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
        if !captureSession.canAddInput(deviceInput) { return }
        captureSession.addInput(deviceInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if !captureSession.canAddOutput(metadataOutput) { return }
        captureSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
    }
    // MEMO: 呼び出し元の`viewDidLayoutSubviews()`で実行しないとautolayoutが崩れるためpublicメソッドにした
    public func configPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }
}

// MARK: - Session

extension KikurageQRCodeReaderView {
    public func startRunning() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
}

// MARK: - AVCaptureMetadataOutputObjects Delegate

extension KikurageQRCodeReaderView: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            guard let value = metadata.stringValue else { return }
            
            captureSession.stopRunning()
            readQRcodeString?(value)
        }
    }
}
