//
//  ClientError.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

/// クライアントエラー
enum ClientError: Error {
    case parseField // パースエラー
    case unknown    // 想定外エラー
}
