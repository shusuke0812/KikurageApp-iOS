//
//  LoginUser.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/10/2.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

struct LoginUser {
    /// ログイン用ユーザー識別ID
    var uid: String

    init(uid: String) {
        self.uid = uid
    }
}
