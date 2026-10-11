//
//  WiFiSelectDeviceState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation
import UIKit

public struct WiFiDeviceInfo: Identifiable {
    public let id: Int
    public let signalImage: UIImage?
    public let rssiString: String
    public let deviceName: String
    public let serviceCountString: String

    public init(id: Int, signalImage: UIImage?, rssiString: String, deviceName: String, serviceCountString: String) {
        self.id = id
        self.signalImage = signalImage
        self.rssiString = rssiString
        self.deviceName = deviceName
        self.serviceCountString = serviceCountString
    }
}

public final class WiFiSelectDeviceState: ObservableObject {
    @Published public var isScanning: Bool = false
    @Published public var isConnecting: Bool = false
    @Published public var devices: [WiFiDeviceInfo] = []
    @Published public var sectionTitle: String = ""

    public init() {}
}
