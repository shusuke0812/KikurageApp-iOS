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
        static let facebook = "https://www.facebook.com/groups/kikurage.community.2019/"
        /// 利用規約
        static let terms = "https://docs.google.com/document/d/1xwKhNVNW-CUuRFp_jk8vhMG1TaihEtrzbEM9RPy77Ac/edit?usp=sharing"
        /// 個人情報保護方針
        static let privacyPolicy = "https://docs.google.com/document/d/1xwKhNVNW-CUuRFp_jk8vhMG1TaihEtrzbEM9RPy77Ac/edit?usp=sharing"
    }
    struct FirestoreCollectionName {
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
    struct CameraCollectionCell {
        /// 画像選択の最大数
        static let maxNumber = 8
    }
    struct TextFieldTag {
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
    struct ViewTag {
        /// サイドメニューのBaseViewタグ番号
        static let sideMenuBase = 1
    }
    struct Image {
        /// 画像読み込み中の表示
        static let loading = R.image.loading()
    }
    struct UserDefaultsKey {
        static let firebaseUser = "firebase_user"
    }
}
