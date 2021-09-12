//
//  NetworkError.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

/// ネットワークエラー
enum NetworkError: Error {
    case invalidUrl         // 不正なURL
    case invalidResponse    // 不正なレスポンス
    case unknown            // 想定外エラー
    func description() -> String {
        switch self {
        case .invalidUrl:       return "DEBUG： 不正なURLです"
        case .invalidResponse:  return "DEBUG： 不正なレスポンスです"
        case .unknown:          return "DEBUG： レスポンスに失敗しました"
        }
    }
}
