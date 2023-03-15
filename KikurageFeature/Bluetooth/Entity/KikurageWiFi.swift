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

    // for cleaned list of tableView
    public func isFastCount() -> Bool {
        count == 1
    }
}

public struct KikurageWiFiList {
    public var list: [KikurageWiFi]

    public init() {
        self.list = []
    }

    public func getWiFiTitle(indexPath: IndexPath) -> String {
        let index = indexPath.row

        if index >= list.count {
            return ""
        }
        return list[indexPath.row].ssid
    }
}
