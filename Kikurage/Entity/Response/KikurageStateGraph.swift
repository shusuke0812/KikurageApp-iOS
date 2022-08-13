//
//  KikurageStateGraph.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/14.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import RealmSwift

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
    var date: Date?
    var temperature: Int?
    var humidity: Int?

    enum CodingKeys: String, CodingKey {
        case date
        case temperature
        case humidity
    }
}

extension KikurageStateGraph: Persistable {
    init(managedObject: KikurageStateGraphObject) {
        mondayData = managedObject.mondayData
        tuesdayData = managedObject.tuesdayData
        wednesdayData = managedObject.wednesdayData
        thursdayData = managedObject.thursdayData
        fridayData = managedObject.fridayData
        saturdayData = managedObject.saturdayData
        sundayData = managedObject.sundayData
    }
    func managedObject() -> KikurageStateGraphObject {
        let kikurageStateGraphObject = KikurageStateGraphObject()
        kikurageStateGraphObject.mondayData = mondayData
        kikurageStateGraphObject.tuesdayData = tuesdayData
        kikurageStateGraphObject.wednesdayData = wednesdayData
        kikurageStateGraphObject.thursdayData = thursdayData
        kikurageStateGraphObject.fridayData = fridayData
        kikurageStateGraphObject.saturdayData = saturdayData
        kikurageStateGraphObject.sundayData = sundayData
        return kikurageStateGraphObject
    }
}

// MARK: - Realm

final class KikurageStateGraphObject: Object {
    dynamic var graphId: String = UUID().uuidString
    dynamic var mondayData: TimeData?
    dynamic var tuesdayData: TimeData?
    dynamic var wednesdayData: TimeData?
    dynamic var thursdayData: TimeData?
    dynamic var fridayData: TimeData?
    dynamic var saturdayData: TimeData?
    dynamic var sundayData: TimeData?
    
    override static func primaryKey() -> String? {
        return "graphId"
    }
}

final class TimeDataObject: Object {
    dynamic var date: Date?
    dynamic var temperature: Int?
    dynamic var humidity: Int?
}
