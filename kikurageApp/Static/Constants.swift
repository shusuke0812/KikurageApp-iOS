//
//  Constants.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

struct Constants {
    struct WebUrl {
        /// Facebookのきくらげコミュニティ
        internal static let facebook = "https://www.facebook.com/groups/kikurage.community.2019/"
        /// 利用規約
        internal static let terms = "https://docs.google.com/document/d/1xwKhNVNW-CUuRFp_jk8vhMG1TaihEtrzbEM9RPy77Ac/edit?usp=sharing"
        /// 個人情報保護方針
        internal static let privacyPolicy = "https://docs.google.com/document/d/1xwKhNVNW-CUuRFp_jk8vhMG1TaihEtrzbEM9RPy77Ac/edit?usp=sharing"
    }
    struct FirestoreCollectionName {
        /// 栽培ステートコレクション
        internal static let states = "kikurageStates"
        /// 栽培ステート配下のグラフサブコレクション名
        internal static let graph = "graph"
        /// ユーザーコレクション名
        internal static let users = "kikurageUsers"
        /// ユーザー配下の栽培サブコレクション名
        internal static let cultivations = "cultivations"
        /// ユーザー配下の料理サブコレクション名
        internal static let recipes = "recipes"
    }
    struct CameraCollectionCell {
        /// 画像選択の最大数
        internal static let maxNumber = 8
    }
    struct TextFieldTag {
        /// 料理名のTextFieldタグ番号
        internal static let recipeName = 1
        /// 料理記録画面の日付のTextFieldタグ番号
        internal static let recipeDate = 2
        /// プロダクトキーのTextFieldタグ番号
        internal static let productKey = 3
        /// きくらげ名のTextFieldタグ番号
        internal static let kikurageName = 4
        /// きくらげ栽培開始日のTextFieldタグ番号
        internal static let cultivationStartDate = 5
    }
    struct ViewTag {
        /// サイドメニューのBaseViewタグ番号
        internal static let sideMenuBase = 1
    }
    struct Image {
        /// 画像読み込み中の表示
        internal static let loading = UIImage(named: "loading")
    }
    struct UserDefaultsKey {
        internal static let userId = "userId"
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
