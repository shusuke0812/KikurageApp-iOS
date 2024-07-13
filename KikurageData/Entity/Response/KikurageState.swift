//
//  KikurageState.swift
//  KikurageData
//
//  Created by Shusuke Ota on 2024/7/13.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Foundation

struct KikurageState: Codable {
    var temperature: Int?
    var humidity: Int?
    var message: String?
    var typeString: String? // dry, normal, hot
    var advice: String?

    enum CodingKeys: String, CodingKey {
        case temperature
        case humidity
        case message
        case typeString = "judge"
        case advice
    }

    var type: KikurageStateType? {
        if typeString == KikurageStateType.normal.rawValue {
            return .normal
        } else if typeString == KikurageStateType.wet.rawValue {
            return .wet
        } else if typeString == KikurageStateType.dry.rawValue {
            return .dry
        } else {
            return nil
        }
    }
}

enum KikurageStateType: String, Codable {
    case normal
    case wet
    case dry
}
