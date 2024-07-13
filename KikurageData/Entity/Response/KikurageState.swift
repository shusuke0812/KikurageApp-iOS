//
//  KikurageState.swift
//  KikurageData
//
//  Created by Shusuke Ota on 2024/7/13.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Foundation

public struct KikurageState: Codable {
    var temperature: Int?
    var humidity: Int?
    var message: String?
    var typeString: String? // dry, normal, hot
    var advice: String?

    public enum CodingKeys: String, CodingKey {
        case temperature
        case humidity
        case message
        case typeString = "judge"
        case advice
    }

    public var type: KikurageStateType? {
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

public enum KikurageStateType: String, Codable {
    case normal
    case wet
    case dry
}
