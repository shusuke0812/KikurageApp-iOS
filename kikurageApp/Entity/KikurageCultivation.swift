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
    var imageStoragePath: [String] = []
    /// 栽培観察日
    var viewDate: String = ""
    /// 投稿日
    var createdAt: Timestamp?
    /// 更新日
    var updatedAt: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case memo
        case imageStoragePath
        case viewDate
        case createdAt
        case updatedAt
    }
}
