//
//  FirebaseClientError.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import Foundation

public enum FirebaseClientError: Error {
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

    public func description() -> String {
        switch self {
        case .networkConnectionError:
            return NSLocalizedString("error_firebase_create", bundle: .main, comment: "")
        case .parseError:
            return NSLocalizedString("error_client_parse", bundle: .main, comment: "")
        case .responseParseError:
            return NSLocalizedString("error_client_response_parse", bundle: .main, comment: "")
        case .apiError:
            return NSLocalizedString("error_client_api", bundle: .main, comment: "")
        case .unknown:
            return NSLocalizedString("error_client_unknown", bundle: .main, comment: "")
        case .saveUserDefaultsError:
            return NSLocalizedString("error_client_save_user_defaults", bundle: .main, comment: "")
        }
    }
}
