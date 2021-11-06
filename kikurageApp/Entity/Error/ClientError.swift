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
    /// エンコード、デコードに失敗
    case parseError(Error)
    /// レスポンスの変換に失敗（ex. レスポンスのJSON形式とResonse型がアンマッチ、JSONデータが一部欠けていた etc）
    case responseParseError(Error)
    /// APIからのエラーレスポンス（400-500番台）
    case apiError(FirebaseAPIError)
    /// 不明なエラー
    case unknown
    /// UserDefaultsの保存に失敗
    case saveUserDefaultsError

    func description() -> String {
        switch self {
        case .networkConnectionError:   return "ネットワーク通信に失敗しました"
        case .parseError:               return "パースエラー"
        case .responseParseError:       return "レスポンスの変換に失敗しました"
        case .apiError:                 return "サーバーエラー"
        case .unknown:                  return "エラーが発生しました"
        case .saveUserDefaultsError:    return "UserDefaultsへの保存に失敗しました"
        }
    }
}
