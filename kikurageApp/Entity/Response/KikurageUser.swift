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
    var cultivationStartDate = Date()
    /// ステートリファレンス
    var stateRef: DocumentReference?
    /// 投稿日
    var createdAt: Timestamp?
    /// 更新日
    var updatedAt: Timestamp?

    enum CodingKeys: String, CodingKey {
        case productKey
        case kikurageName
        case cultivationStartDate
        case stateRef
        case createdAt
        case updatedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.productKey, forKey: .productKey)
        try container.encode(self.kikurageName, forKey: .kikurageName)
        try container.encode(self.cultivationStartDate, forKey: .cultivationStartDate)
        try container.encode(self.stateRef, forKey: .stateRef)
        if self.createdAt == nil {
            try container.encode(FieldValue.serverTimestamp(), forKey: .createdAt)
        }
        try container.encode(FieldValue.serverTimestamp(), forKey: .updatedAt)
    }
}
