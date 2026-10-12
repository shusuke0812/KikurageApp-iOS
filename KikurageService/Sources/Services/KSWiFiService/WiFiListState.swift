//
//  WiFiListState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

public struct WiFiListSpecItem: Identifiable {
    public let id: String
    public let title: String
    public let stateTitle: String

    public init(id: String, title: String, stateTitle: String) {
        self.id = id
        self.title = title
        self.stateTitle = stateTitle
    }
}

public struct WiFiListSelectableItem: Identifiable {
    public let id: String
    public let title: String
    public let ssid: String

    public init(id: String, title: String, ssid: String) {
        self.id = id
        self.title = title
        self.ssid = ssid
    }
}

public final class WiFiListState: ObservableObject {
    @Published public var specSectionTitle: String = ""
    @Published public var specItems: [WiFiListSpecItem] = []

    @Published public var enterWifiSectionTitle: String = ""
    @Published public var enterWifiItems: [WiFiListSelectableItem] = []

    @Published public var selectWifiSectionTitle: String = ""
    @Published public var selectWifiItems: [WiFiListSelectableItem] = []
    @Published public var isScanning: Bool = false

    public init() {}
}
