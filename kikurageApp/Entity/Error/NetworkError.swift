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
    /// 不正なURL
    case invalidUrl
    /// 不正なレスポンス
    case invalidResponse
    /// 想定外エラー
    case unknown
    /// エラー文言を返す
    func description() -> String {
        switch self {
        case .invalidUrl:       return "不正なURLです"
        case .invalidResponse:  return "不正なレスポンスです"
        case .unknown:          return "レスポンスに失敗しました"
        }
    }
}
