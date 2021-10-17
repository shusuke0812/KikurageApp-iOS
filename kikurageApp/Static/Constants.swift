//
//  Constants.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

enum Constants {
    enum WebUrl {
        /// Facebookのきくらげコミュニティ
        static let facebook = "https://www.facebook.com/groups/kikurage.community.2019/"
        /// 利用規約
        static let terms = "https://docs.google.com/document/d/1xwKhNVNW-CUuRFp_jk8vhMG1TaihEtrzbEM9RPy77Ac/edit?usp=sharing"
        /// 個人情報保護方針
        static let privacyPolicy = "https://docs.google.com/document/d/1xwKhNVNW-CUuRFp_jk8vhMG1TaihEtrzbEM9RPy77Ac/edit?usp=sharing"
    }
    enum FirestoreCollectionName {
        /// 栽培ステートコレクション
        static let states = "kikurageStates"
        /// 栽培ステート配下のグラフサブコレクション名
        static let graph = "graph"
        /// ユーザーコレクション名
        static let users = "kikurageUsers"
        /// ユーザー配下の栽培サブコレクション名
        static let cultivations = "cultivations"
        /// ユーザー配下の料理サブコレクション名
        static let recipes = "recipes"
    }
    enum CameraCollectionCell {
        /// 画像選択の最大数
        static let maxNumber = 8
    }
    // TODO: Tagは使わない方が良い、enumに置き換え
    enum TextFieldTag {
        /// 料理名のTextFieldタグ番号
        static let recipeName = 1
        /// 料理記録画面の日付のTextFieldタグ番号
        static let recipeDate = 2
        /// プロダクトキーのTextFieldタグ番号
        static let productKey = 3
        /// きくらげ名のTextFieldタグ番号
        static let kikurageName = 4
        /// きくらげ栽培開始日のTextFieldタグ番号
        static let cultivationStartDate = 5
        /// メールアドレス
        static let email = 6
        /// パスワード
        static let password = 7
    }
    enum ViewTag {
        /// サイドメニューのBaseViewタグ番号
        static let sideMenuBase = 1
    }
    enum Image {
        /// 画像読み込み中の表示
        static let loading = R.image.loading()
    }
    enum UserDefaultsKey {
        static let firebaseUser = "firebase_user"
    }
    enum Week: String, CaseIterable {
        case monday     = "月曜"
        case tuesday    = "火曜"
        case wednesday  = "水曜"
        case thursday   = "木曜"
        case friday     = "金曜"
        case saturday   = "土曜"
        case sunday     = "日曜"
    }
}
