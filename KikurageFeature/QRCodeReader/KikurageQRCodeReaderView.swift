//
//  KikurageQRCodeReaderView.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/2/4.
//  Copyright © 2022 shusuke. All rights reserved.
//

import AVFoundation
import UIKit

public class KikurageQRCodeReaderView: UIView {
    public var windowOrientation: UIInterfaceOrientation {
        window?.windowScene?.interfaceOrientation ?? .unknown
    }

    public var previewLayer: AVCaptureVideoPreviewLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Initialize

    // MEMO: 呼び出し元の`viewDidLayoutSubviews()`で実行しないとautolayoutが崩れるためpublicメソッドにした
    public func configPreviewLayer(captureSession: AVCaptureSession) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)

        self.previewLayer = previewLayer
    }

    public func configCaptureOrientation(_ orientation: AVCaptureVideoOrientation) {
        previewLayer?.connection?.videoOrientation = orientation
    }
}
