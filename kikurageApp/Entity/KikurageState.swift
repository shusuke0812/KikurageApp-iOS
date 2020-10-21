//
//  KikurageState.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct KikurageState: Codable {
    /// 温度
    var temperature: Int?
    /// 湿度
    var humidity: Int?
    /// 状態メッセージ
    var message: String?
    /// 判定（dry, normal, hot）
    var judge: String?
    /// アドバイス
    var advice: String?
    /// ユーザーリファレンス
    let userRef: DocumentReference?
}
