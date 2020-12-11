//
//  Constants.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

struct Constants {
    struct WebUrl {
        /// Facebookのきくらげコミュニティ
        internal static let facebook = "https://www.facebook.com/groups/kikurage.community.2019/"
    }
    struct FirestoreCollectionName {
        /// ユーザーコレクション名
        internal static let users = "kikurageUsers"
        /// ユーザー
        /// 配下の栽培サブコレクション名
        internal static let cultivations = "cultivations"
    }
    struct CameraCollectionCell {
        /// 画像選択の最大数
        internal static let maxNumber = 8
    }
}

/// ネットワークエラー
enum NetworkError: Error {
    case invalidUrl         // 不正なURL
    case invalidResponse    // 不正なレスポンス
    case unknown            // 想定外エラー
    func description() -> String {
        switch self {
            case .invalidUrl:       return "DEBUG： 不正なURLです"
            case .invalidResponse:  return "DEBUG： 不正なレスポンスです"
            case .unknown:          return "DEBUG： レスポンスに失敗しました"
        }
    }
}
/// クライアントエラー
enum ClientError: Error {
    case parseField // パースエラー
    case unknown    // 想定外エラー
}
