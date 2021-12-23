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
    /// タイプ（dry, normal, hot）
    var type: KikurageStateType?
    /// アドバイス
    var advice: String?
}

enum KikurageStateType: String, Codable {
    case normal
    case wet
    case dry
}
