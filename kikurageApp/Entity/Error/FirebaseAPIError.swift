//
//  NetworkError.swift
//  kikurageApp
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
    case documentIdError
    /// ユーザ情報の取得に失敗
    case loadUserError

    func description() -> String {
        switch self {
        case .createError:              return "作成に失敗しました"
        case .readError:                return "読み込みに失敗しました"
        case .deleteError:              return "削除に失敗しました"
        case .updateError:              return "更新に失敗しました"
        case .documentIdError:          return "ドキュメントIDが見つかりません"
        case .loadUserError:            return "ユーザー情報の取得に失敗しました"
        }
    }
}
