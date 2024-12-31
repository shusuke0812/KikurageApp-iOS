//
//  File.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import Foundation

public enum FirestoreCollectionName {
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
