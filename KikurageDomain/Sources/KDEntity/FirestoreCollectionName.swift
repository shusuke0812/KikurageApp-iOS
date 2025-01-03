//
//  FirestoreCollectionName.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import Foundation

public enum FirestoreCollectionName {
    /// 栽培ステートコレクション
    public static let states = "kikurageStates"
    /// 栽培ステート配下のグラフサブコレクション名
    public static let graph = "graph"
    /// ユーザーコレクション名
    public static let users = "kikurageUsers"
    /// ユーザー配下の栽培サブコレクション名
    public static let cultivations = "cultivations"
    /// ユーザー配下の料理サブコレクション名
    public static let recipes = "recipes"
}
