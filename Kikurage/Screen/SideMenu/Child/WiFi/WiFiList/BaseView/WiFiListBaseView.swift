//
//  WiFiListBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KSWiFiService
import SwiftUI

protocol WiFiListBaseViewDelegate: AnyObject {
    func wifiListBaseViewDidSelectWiFi(ssid: String)
}

struct WiFiListBaseView: View {
    @StateObject var state: WiFiListState
    weak var delegate: WiFiListBaseViewDelegate?

    init(state: WiFiListState, delegate: WiFiListBaseViewDelegate?) {
        _state = StateObject(wrappedValue: state)
        self.delegate = delegate
    }

    var body: some View {
        List {
            Section(state.specSectionTitle) {
                ForEach(state.specItems) { item in
                    HStack {
                        Text(item.title)
                        Spacer(minLength: 0)
                        Text(item.stateTitle)
                            .foregroundColor(.gray)
                    }
                }
            }

            Section(state.enterWifiSectionTitle) {
                ForEach(state.enterWifiItems) { item in
                    WiFiSelectableRow(title: item.title)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            delegate?.wifiListBaseViewDidSelectWiFi(ssid: item.ssid)
                        }
                }
            }

            Section {
                ForEach(state.selectWifiItems) { item in
                    WiFiSelectableRow(title: item.title)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            delegate?.wifiListBaseViewDidSelectWiFi(ssid: item.ssid)
                        }
                }
            } header: {
                HStack(spacing: 8) {
                    Text(state.selectWifiSectionTitle)
                    if state.isScanning {
                        ProgressView()
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct WiFiSelectableRow: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(uiColor: .systemGray3))
        }
    }
}

#Preview {
    let state = WiFiListState()
    state.specSectionTitle = "デバイス情報"
    state.specItems = [
        WiFiListSpecItem(id: "1", title: "デバイス名", stateTitle: "Kikurage-Device-01"),
        WiFiListSpecItem(id: "2", title: "デバイスID", stateTitle: "XXXXXXXXXXXXXX****"),
        WiFiListSpecItem(id: "3", title: "RSSI", stateTitle: "-50")
    ]
    state.enterWifiSectionTitle = "手動で入力"
    state.enterWifiItems = [WiFiListSelectableItem(id: "enter", title: "Wi-Fiを入力する", ssid: "")]
    state.selectWifiSectionTitle = "Wi-Fiを選択"
    state.selectWifiItems = [
        WiFiListSelectableItem(id: "wifi1", title: "Kikurage-WiFi", ssid: "Kikurage-WiFi"),
        WiFiListSelectableItem(id: "wifi2", title: "Guest-WiFi", ssid: "Guest-WiFi")
    ]
    state.isScanning = true
    return WiFiListBaseView(state: state, delegate: nil)
}
