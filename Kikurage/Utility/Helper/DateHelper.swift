//
//  DateHelper.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

struct DateHelper {
    private init() {}

    private static let defaultDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    private static let originalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    /// 現在時刻を取得する
    static func now() -> String {
        let now = Date()
        return self.defaultDateFormatter.string(from: now)
    }
    /// Date型を指定したString型に変換する
    /// - Parameter date: 日付
    static func formatToString(date: Date) -> String {
        self.originalDateFormatter.dateFormat = "yyyy/MM/dd"
        return self.originalDateFormatter.string(from: date)
    }
    /// Date型を画像ファイル名に使うString型に変換する
    /// - Parameter date: 日付
    static func formatToStringForImageData(date: Date) -> String {
        self.originalDateFormatter.dateFormat = "yyyyMMddHHmmss"
        return self.originalDateFormatter.string(from: date)
    }
    /// Date型をログに使うString型へ変換する
    static func formatToStringForLog() -> String {
        self.originalDateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return self.originalDateFormatter.string(from: Date())
    }
}
