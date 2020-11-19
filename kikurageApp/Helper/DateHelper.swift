//
//  DateHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

class DateHelper {
    /// Dateを指定したStringに変換する
    internal func formatToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}
