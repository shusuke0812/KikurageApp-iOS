//
//  DeviceRegisterState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/3/14.
//

import AVFoundation
import Combine
import Foundation
import KSSDateHelper

public final class DeviceRegisterState: ObservableObject {
    @Published public var productKey: String = ""
    @Published public var kikurageName: String = ""
    @Published public var cultivationStartDate: Date = Date()
    @Published public var isQrcodeReaderVisible: Bool = false
    @Published public var captureSession: AVCaptureSession?
    @Published public var videoOrientation: AVCaptureVideoOrientation?
    @Published public var canRegister: Bool = false

    /// validation 用（DateHelper.formatToString でフォーマット）
    public var cultivationStartDateString: String {
        DateHelper.formatToString(date: cultivationStartDate)
    }

    public init() {}
}
