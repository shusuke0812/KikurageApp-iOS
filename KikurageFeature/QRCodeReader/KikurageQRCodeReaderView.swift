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
    public var catchError: ((Error) -> Void)?
    
    private let captureSession = AVCaptureSession()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Initialize

extension KikurageQRCodeReaderView {
    // MEMO: 呼び出し元の`viewDidLayoutSubviews()`で実行しないとautolayoutが崩れるためpublicメソッドにした
    public func configPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }
}
