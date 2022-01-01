//
//  KikurageState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

struct KikurageState: Codable {
    /// 温度
    var temperature: Int?
    /// 湿度
    var humidity: Int?
    /// 状態メッセージ
    var message: String?
    /// タイプ文字列（dry, normal, hot）
    var typeString: String?
    /// アドバイス
    var advice: String?

    enum CodingKeys: String, CodingKey {
        case temperature
        case humidity
        case message
        case typeString = "judge"
        case advice
    }

    /// タイプ
    var type: KikurageStateType?

    /// タイプ文字列を`KikurageStateType`に変換する
    mutating func convertToStateType() {
        if typeString == KikurageStateType.normal.rawValue {
            type = .normal
        } else if typeString == KikurageStateType.wet.rawValue {
            type = .wet
        } else if typeString == KikurageStateType.dry.rawValue {
            type = .dry
        }
    }
}

enum KikurageStateType: String, Codable {
    case normal
    case wet
    case dry
}
