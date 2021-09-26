//
//  DateHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

class DateHelper {
    /// シングルトン
    static let shared = DateHelper()

    private let formatter: DateFormatter

    private init() {
        self.formatter = DateFormatter()
    }
}
extension DateHelper {
    /// Date型を指定したString型に変換する
    /// - Parameter date: 日付
    func formatToString(date: Date) -> String {
        self.formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    /// Date型を画像ファイル名に使うString型に変換する
    /// - Parameter date: 日付
    func formatToStringForImageData(date: Date) -> String {
        self.formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: date)
    }
    /// Date型をログに使うString型へ変換する
    func formatToStringForLog() -> String {
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
