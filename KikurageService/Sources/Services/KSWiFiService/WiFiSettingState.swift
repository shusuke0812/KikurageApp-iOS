//
//  WiFiSettingState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

public enum WiFiSettingAlert: Identifiable {
    case success(message: String)
    case failure(message: String)

    public var id: String {
        switch self {
        case .success(let message):
            return "success-\(message)"
        case .failure(let message):
            return "failure-\(message)"
        }
    }

    public var message: String {
        switch self {
        case .success(let message), .failure(let message):
            return message
        }
    }
}

public final class WiFiSettingState: ObservableObject {
    @Published public var ssid: String = ""
    @Published public var password: String = ""
    @Published public var isSettingUp: Bool = false
    @Published public var alert: WiFiSettingAlert?

    public var isButtonEnabled: Bool {
        !ssid.isEmpty && !password.isEmpty
    }

    public init() {}
}
