//
//  FirebaseAPIError.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

enum FirebaseAPIError: Error {
    case createError
    case readError
    case deleteError
    case updateError

    /// FirestoreのドキュメントIDが見つからない
    case documentIDError
    /// ユーザ情報の取得に失敗
    case loadUserError

    func description() -> String {
        switch self {
        case .createError:
            return R.string.localizable.error_firebase_create()
        case .readError:
            return R.string.localizable.error_firebase_read()
        case .deleteError:
            return R.string.localizable.error_firebase_delete()
        case .updateError:
            return R.string.localizable.error_firebase_update()
        case .documentIDError:
            return R.string.localizable.error_firebase_document_id()
        case .loadUserError:
            return R.string.localizable.error_firebase_load_user()
        }
    }
}
