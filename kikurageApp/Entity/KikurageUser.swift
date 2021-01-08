//
//  KikurageUser.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct KikurageUser: Codable {
    /// 製品シリアルコード
    var productKey: String = ""
    /// きくらげ 君（筐体）の名前
    var kikurageName: String = ""
    /// 栽培開始日
    var startDate: Date = Date()
    /// ステートリファレンス
    var stateRef: DocumentReference?
}
