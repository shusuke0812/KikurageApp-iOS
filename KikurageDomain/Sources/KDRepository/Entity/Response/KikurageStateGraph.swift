//
//  KikurageStateGraph.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/14.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

public typealias KikurageStateGraphTuple = (data: KikurageStateGraph, documentID: String)

public struct KikurageStateGraph: Codable {
    public var mondayData: TimeData?
    public var tuesdayData: TimeData?
    public var wednesdayData: TimeData?
    public var thursdayData: TimeData?
    public var fridayData: TimeData?
    public var saturdayData: TimeData?
    public var sundayData: TimeData?

    public enum CodingKeys: String, CodingKey {
        case mondayData = "monday"
        case tuesdayData = "tuesday"
        case wednesdayData = "wednesday"
        case thursdayData = "thursday"
        case fridayData = "friday"
        case saturdayData = "saturday"
        case sundayData = "sunday"
    }
}

public struct TimeData: Codable {
    public var date: Date?
    public var temperature: Int?
    public var humidity: Int?

    public enum CodingKeys: String, CodingKey {
        case date
        case temperature
        case humidity
    }
}
