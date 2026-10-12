//
//  WiFiListState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

struct WiFiListSpecItem: Identifiable {
    let id: String
    let title: String
    let stateTitle: String
}

struct WiFiListSelectableItem: Identifiable {
    let id: String
    let title: String
    let ssid: String
}

final class WiFiListState: ObservableObject {
    @Published var specSectionTitle: String = ""
    @Published var specItems: [WiFiListSpecItem] = []

    @Published var enterWifiSectionTitle: String = ""
    @Published var enterWifiItems: [WiFiListSelectableItem] = []

    @Published var selectWifiSectionTitle: String = ""
    @Published var selectWifiItems: [WiFiListSelectableItem] = []
    @Published var isScanning: Bool = false
}
