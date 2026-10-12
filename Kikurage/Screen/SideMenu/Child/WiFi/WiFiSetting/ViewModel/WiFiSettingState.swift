//
//  WiFiSettingState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

enum WiFiSettingAlert: Identifiable {
    case success(message: String)
    case failure(message: String)

    var id: String {
        switch self {
        case .success(let message):
            return "success-\(message)"
        case .failure(let message):
            return "failure-\(message)"
        }
    }

    var message: String {
        switch self {
        case .success(let message), .failure(let message):
            return message
        }
    }
}

final class WiFiSettingState: ObservableObject {
    @Published var ssid: String = ""
    @Published var password: String = ""
    @Published var isSettingUp: Bool = false
    @Published var alert: WiFiSettingAlert?

    var isButtonEnabled: Bool {
        !ssid.isEmpty && !password.isEmpty
    }
}
