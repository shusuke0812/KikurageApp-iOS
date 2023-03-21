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
        return defaultDateFormatter.string(from: now)
    }

    /// Date型を指定したString型に変換する
    /// - Parameter date: 日付
    static func formatToString(date: Date) -> String {
        originalDateFormatter.dateFormat = "yyyy/MM/dd"
        return originalDateFormatter.string(from: date)
    }

    /// Date型を画像ファイル名に使うString型に変換する
    /// - Parameter date: 日付
    static func formatToStringForImageData(date: Date) -> String {
        originalDateFormatter.dateFormat = "yyyyMMddHHmmss"
        return originalDateFormatter.string(from: date)
    }

    /// String型をDate型に変換する
    static func formatToDate(dateString: String) -> Date? {
        originalDateFormatter.dateFormat = "yyyy/MM/dd"
        return originalDateFormatter.date(from: dateString)
    }

    /// Date型からDateComponentsを取得する
    /// - Parameter date: 日付（デフォルトは現在時刻）
    static func getDateComponents(date: Date = Date()) -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: date)
    }

    /// `TwitterSearchAPI`レスポンスに使用する
    static let twitterSearchDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZZZ yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
