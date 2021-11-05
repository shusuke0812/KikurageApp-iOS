//
//  ClientError.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

enum ClientError: Error {
    /// 通信に失敗（ex. 端末オフライン、URLホストが見つからない etc）
    case networkConnectionError(Error)
    /// レスポンスの変換に失敗（ex. レスポンスのJSON形式とResonse型がアンマッチ、JSONデータが一部欠けていた etc）
    case responseParseError(Error)
    /// APIからのエラーレスポンス（400-500番台）
    case apiError(FirebaseAPIError)
    /// 不明なエラー
    case unknown
    
    func description() -> String {
        switch self {
        case .networkConnectionError:   return "ネットワーク通信に失敗しました"
        case .responseParseError:       return "レスポンスの変換に失敗しました"
        case .apiError:                 return "サーバーエラー"
        case .unknown:                  return "エラーが発生しました"
        }
    }
}
