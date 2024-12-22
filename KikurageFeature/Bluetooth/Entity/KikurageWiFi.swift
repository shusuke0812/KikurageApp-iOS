//
//  KikurageWiFi.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/15.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public struct KikurageWiFi: Decodable {
    public let totalCount: Int
    public let count: Int
    public let ssid: String
    let channel: Int
    let rssi: Int
    public let isAuthOpen: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case ssid
        case channel
        case rssi
        case isAuthOpen = "is_auth_open"
    }

    public var rssiInt: Int {
        Int(rssi)
    }

    public var channelInt: Int {
        Int(channel)
    }

    // for updated tableView
    public func isLastCount() -> Bool {
        totalCount == count
    }
}

public struct KikurageWiFiList {
    public var list: [KikurageWiFi]

    public init() {
        list = []
    }

    public mutating func addElement(wifi: KikurageWiFi) {
        if let _ = list.first(where: { $0.ssid == wifi.ssid }) {
            return
        }
        list.append(wifi)
    }

    public func getWiFiTitle(indexPath: IndexPath) -> String {
        let index = indexPath.row

        if index >= list.count {
            return ""
        }
        return list[indexPath.row].ssid
    }
}
