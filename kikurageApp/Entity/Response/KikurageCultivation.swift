//
//  KikurageCultivation.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate

struct KikurageCultivation: Codable {
    /// 栽培メモ
    var memo: String = ""
    /// 栽培写真
    var imageStoragePaths: [String] = []
    /// 栽培観察日
    var viewDate: String = ""
    /// 投稿日
    var createdAt: Timestamp?
    /// 更新日
    var updatedAt: Timestamp?

    enum CodingKeys: String, CodingKey {
        case memo
        case imageStoragePaths
        case viewDate
        case createdAt
        case updatedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.memo, forKey: .memo)
        try container.encode(self.imageStoragePaths, forKey: .imageStoragePaths)
        try container.encode(self.viewDate, forKey: .viewDate)
        if self.createdAt == nil {
            try container.encode(FieldValue.serverTimestamp(), forKey: .createdAt)
        }
        try container.encode(FieldValue.serverTimestamp(), forKey: .updatedAt)
    }
}
