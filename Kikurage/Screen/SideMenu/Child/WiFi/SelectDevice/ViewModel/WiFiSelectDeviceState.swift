//
//  WiFiSelectDeviceState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation
import UIKit

struct WiFiDeviceInfo: Identifiable {
    let id: Int
    let signalImage: UIImage?
    let rssiString: String
    let deviceName: String
    let serviceCountString: String
}

final class WiFiSelectDeviceState: ObservableObject {
    @Published var isScanning: Bool = false
    @Published var isConnecting: Bool = false
    @Published var devices: [WiFiDeviceInfo] = []
    @Published var sectionTitle: String = ""
}
