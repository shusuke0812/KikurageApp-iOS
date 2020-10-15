//
//  KikurageUser.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

struct KikurageUser {
    /// 製品シリアルコード
    let productKey: String
    /// きくらげ 君（筐体）の名前
    var kikurageName: String?
    /// 栽培開始日
    var startDate: Date?
    
    init(productKey: String) {
        self.productKey = productKey
    }
}
