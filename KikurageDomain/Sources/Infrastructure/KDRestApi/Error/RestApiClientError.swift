//
//  RestApiClientError.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

public enum RestApiClientError: Error {
    /// 通信に失敗（ex. 端末オフライン、URLホストが見つからない etc）
    case networkConnectionError(Error)
    /// エンコード、デコードに失敗
    case parseError(Error)
    /// レスポンスの変換に失敗（ex. レスポンスのJSON形式とResonse型がアンマッチ、JSONデータが一部欠けていた etc）
    case responseParseError(Error)
    /// APIからのエラーレスポンス（400-500番台）
    case apiError(Error)
    /// 不明なエラー
    case unknown
    /// UserDefaultsの保存に失敗
    case saveUserDefaultsError

    public func description() -> String {
        switch self {
        case .networkConnectionError:
            return R.LocalizableString.errorClientNetworkConnection
        case .parseError:
            return R.LocalizableString.errorClientParse
        case .responseParseError:
            return R.LocalizableString.errorClientResponseParse
        case .apiError:
            return R.LocalizableString.errorClientApi
        case .unknown:
            return R.LocalizableString.errorClientUnknown
        case .saveUserDefaultsError:
            return R.LocalizableString.errorClientSaveUserDefaults
        }
    }
}
