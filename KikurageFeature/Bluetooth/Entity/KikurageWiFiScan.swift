//
//  KikurageStopWiFiScan.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/25.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

struct KikurageWiFiScan: Encodable {
    private let isStop: Bool

    init(isStop: Bool) {
        self.isStop = isStop
    }

    enum CodingKeys: String, CodingKey {
        case isStop = "is_stop"
    }
}
