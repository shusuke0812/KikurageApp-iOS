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
    /// パースエラー
    case parseField
    /// 想定外エラー
    case unknown
}
