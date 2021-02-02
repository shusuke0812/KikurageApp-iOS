//
//  KikurageRecipe.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate

struct KikurageRecipe: Codable {
    /// 料理名
    var name: String = ""
    /// 料理メモ
    var memo: String = ""
    /// 料理写真
    var imageStoragePaths: [String] = []
    /// 料理日
    var cookDate: String = ""
    /// 投稿日
    var createdAt: Timestamp?
    /// 更新日
    var updatedAt: Timestamp?

    enum CodingKeys: String, CodingKey {
        case name
        case memo
        case imageStoragePaths
        case cookDate
        case createdAt
        case updatedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.memo, forKey: .memo)
        try container.encode(self.imageStoragePaths, forKey: .imageStoragePaths)
        try container.encode(self.cookDate, forKey: .cookDate)
        if self.createdAt == nil {
            try container.encode(FieldValue.serverTimestamp(), forKey: .createdAt)
        }
        try container.encode(FieldValue.serverTimestamp(), forKey: .updatedAt)
    }
}
