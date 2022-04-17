//
//  KikurageStateGraph.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/14.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

typealias KikurageStateGraphTuple = (data: KikurageStateGraph, documentId: String)

struct KikurageStateGraph: Codable {
    var mondayData: TimeData?
    var tuesdayData: TimeData?
    var wednesdayData: TimeData?
    var thursdayData: TimeData?
    var fridayData: TimeData?
    var saturdayData: TimeData?
    var sundayData: TimeData?

    enum CodingKeys: String, CodingKey {
        case mondayData = "monday"
        case tuesdayData = "tuesday"
        case wednesdayData = "wednesday"
        case thursdayData = "thursday"
        case fridayData = "friday"
        case saturdayData = "saturday"
        case sundayData = "sunday"
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
