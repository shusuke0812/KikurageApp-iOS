//
//  KikurageStateGraph.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/14.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import SwiftDate

struct KikurageStateGraph: Codable {
    // 曜日毎のデータ
    var mondayData: TimeData?
    var tuesdayData: TimeData?
    var wednesdayData: TimeData?
    var thursdayData: TimeData?
    var fridayData: TimeData?
    var saturdayData: TimeData?
    var sundayData: TimeData?
    
    enum CodingKeys: String, CodingKey {
        case mondayData
        case tuesdayData
        case wednesdayData
        case thursdayData
        case fridayData
        case saturdayData
        case sundayData
    }
}

struct TimeData: Codable {
    // 日付
    var date: Date?
    // 温度
    var temperature: Int?
    // 湿度
    var humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case date
        case temperature
        case humidity
    }
}
