//
//  DeviceRegisterState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2025/3/14.
//

import AVFoundation
import Combine
import Foundation

final class DeviceRegisterState: ObservableObject {
    @Published var productKey: String = ""
    @Published var kikurageName: String = ""
    @Published var cultivationStartDate: Date = Date()
    @Published var isQrcodeReaderVisible: Bool = false
    @Published var captureSession: AVCaptureSession?
    @Published var videoOrientation: AVCaptureVideoOrientation?
    @Published var canRegister: Bool = false

    /// validation 用（DateHelper.formatToString でフォーマット）
    var cultivationStartDateString: String {
        DateHelper.formatToString(date: cultivationStartDate)
    }
}
