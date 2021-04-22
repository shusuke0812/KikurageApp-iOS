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

    private let formatter = DateFormatter()
}
extension DateHelper {
    /// Date型を指定したString型に変換する
    /// - Parameter date: 日付
    internal func formatToString(date: Date) -> String {
        self.formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    /// Date型を画像ファイル名に使うString型に変換する
    /// - Parameter date: 日付
    internal func formatToStringForImageData(date: Date) -> String {
        self.formatter.dateFormat = "yyyyMMddHHmmss"
        return formatter.string(from: date)
    }
}
