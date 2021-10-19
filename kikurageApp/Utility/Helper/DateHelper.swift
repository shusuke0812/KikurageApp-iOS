//
//  DateHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

struct DateHelper {
    /// 現在時刻を取得する
    static func now() -> String {
        let now = Date()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium

        return formatter.string(from: now)
    }
    /// Date型を指定したString型に変換する
    /// - Parameter date: 日付
    static func formatToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    /// Date型を画像ファイル名に使うString型に変換する
    /// - Parameter date: 日付
    static func formatToStringForImageData(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: date)
    }
    /// Date型をログに使うString型へ変換する
    static func formatToStringForLog() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
