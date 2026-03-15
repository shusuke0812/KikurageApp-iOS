//
//  QRCodeReaderView.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2022/2/4.
//  Copyright © 2022 shusuke. All rights reserved.
//

import AVFoundation
import SwiftUI
import UIKit

/// QR コード読み取り用カメラプレビュー（SwiftUI 用）
///
/// ZStack や他の SwiftUI レイアウト内でそのまま利用できる。
///
/// ```swift
/// ZStack {
///     QRCodeReaderCameraView(
///         session: viewModel.captureSession,
///         orientation: viewModel.videoOrientation
///     )
/// }
/// ```
public struct QRCodeReaderView: View {
    private let session: AVCaptureSession?
    private let videoOrientation: AVCaptureVideoOrientation?

    public init(
        session: AVCaptureSession?,
        orientation: AVCaptureVideoOrientation? = nil
    ) {
        self.session = session
        self.videoOrientation = orientation
    }

    public var body: some View {
        CameraPreviewRepresentable(
            session: session,
            videoOrientation: videoOrientation
        )
        .ignoresSafeArea()
    }
}

// MARK: - SwiftUI Implementation

/// AVCaptureVideoPreviewLayer を表示する UIViewRepresentable
private struct CameraPreviewRepresentable: UIViewRepresentable {
    let session: AVCaptureSession?
    let videoOrientation: AVCaptureVideoOrientation?

    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        return view
    }

    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        uiView.setSession(session)
        uiView.setVideoOrientation(videoOrientation)
    }
}

/// プレビューレイヤーを保持する UIView（Representable 用）
private final class CameraPreviewUIView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    private var capturePreviewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    func setSession(_ session: AVCaptureSession?) {
        guard capturePreviewLayer.session !== session else { return }
        capturePreviewLayer.session = session
        capturePreviewLayer.videoGravity = .resizeAspectFill
    }

    func setVideoOrientation(_ orientation: AVCaptureVideoOrientation?) {
        guard let orientation else { return }
        capturePreviewLayer.connection?.videoOrientation = orientation
    }
}
