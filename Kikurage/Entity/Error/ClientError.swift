//
//  ClientError.swift
//  Kikurage
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
    case apiError(FirebaseAPIError) // TODO: change general error type, REF: https://github.com/ishkawa/APIKit/tree/2.0.1/Sources
    /// 不明なエラー
    case unknown
    /// UserDefaultsの保存に失敗
    case saveUserDefaultsError

    func description() -> String {
        switch self {
        case .networkConnectionError:   return R.string.localizable.error_client_network_connection()
        case .parseError:               return R.string.localizable.error_client_parse()
        case .responseParseError:       return R.string.localizable.error_client_response_parse()
        case .apiError:                 return R.string.localizable.error_client_api()
        case .unknown:                  return R.string.localizable.error_client_unknown()
        case .saveUserDefaultsError:    return R.string.localizable.error_client_save_user_defaults()
        }
    }
}
