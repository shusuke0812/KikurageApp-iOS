//
//  FirebaseAPIError.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

public enum FirebaseAPIError: Error {
    case createError
    case readError
    case deleteError
    case updateError

    /// FirestoreのドキュメントIDが見つからない
    case documentIDError
    /// ユーザ情報の取得に失敗
    case loadUserError

    public func description() -> String {
        switch self {
        case .createError:
            return R.LocalizableString.errorFirebaseCreate
        case .readError:
            return R.LocalizableString.errorFirebaseRead
        case .deleteError:
            return R.LocalizableString.errorFirebaseDelete
        case .updateError:
            return R.LocalizableString.errorFirebaseUpdate
        case .documentIDError:
            return R.LocalizableString.errorFirebaseDocumentID
        case .loadUserError:
            return R.LocalizableString.errorFirebaseLoadUser
        }
    }
}
