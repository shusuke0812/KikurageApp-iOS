//
//  FirebaseAPIError.swift
//  Kikurage
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
            return NSLocalizedString("error_firebase_create", bundle: .main, comment: "")
        case .readError:
            return NSLocalizedString("error_firebase_read", bundle: .main, comment: "")
        case .deleteError:
            return NSLocalizedString("error_firebase_delete", bundle: .main, comment: "")
        case .updateError:
            return NSLocalizedString("error_firebase_update", bundle: .main, comment: "")
        case .documentIDError:
            return NSLocalizedString("error_firebase_document_id", bundle: .main, comment: "")
        case .loadUserError:
            return NSLocalizedString("error_firebase_load_user", bundle: .main, comment: "")
        }
    }
}
