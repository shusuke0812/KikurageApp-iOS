//
//  KikurageState.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct KikurageState {
    /// 温度
    var temperature: Double?
    /// 湿度
    var humidity: Double?
    /// 状態メッセージ
    var message: String?
    /// 判定（dry, normal, hot）
    var judge: String?
    /// ユーザーリファレンス
    let userRef: DocumentReference?
}
