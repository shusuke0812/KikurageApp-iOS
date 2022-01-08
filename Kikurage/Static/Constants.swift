//
//  Constants.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

enum Constants {
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
    enum UserDefaultsKey {
        static let firebaseUser = "firebase_user"
    }
    enum Week: String, CaseIterable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday

        var localizedString: String {
            switch self {
            case .monday:       return R.string.localizable.common_week_monday()
            case .tuesday:      return R.string.localizable.common_week_tuesday()
            case .wednesday:    return R.string.localizable.common_week_wednesday()
            case .thursday:     return R.string.localizable.common_week_thursday()
            case .friday:       return R.string.localizable.common_week_friday()
            case .saturday:     return R.string.localizable.common_week_saturday()
            case .sunday:       return R.string.localizable.common_week_sunday()
            }
        }
    }
    enum Email {
        static let address = "kikurageproject2019@googlegroups.com"
    }
    enum Color: RawRepresentable {
        case cultivation
        case recipe
        case communication

        typealias RawValue = UIColor

        init?(rawValue: RawValue) {
            switch rawValue {
            case UIColor(hex: "4A90E2"):   self = .cultivation
            case UIColor(hex: "F5A623"):   self = .recipe
            case UIColor(hex: "7ED321"):   self = .communication
            default:    return nil
            }
        }

        var rawValue: RawValue {
            switch self {
            case .cultivation:      return UIColor(hex: "4A90E2")
            case .recipe:           return UIColor(hex: "F5A623")
            case .communication:    return UIColor(hex: "7ED321")
            }
        }
    }
}
