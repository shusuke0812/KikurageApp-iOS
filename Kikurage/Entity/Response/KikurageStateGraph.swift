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

extension KikurageStateGraph: RealmCodable {
    func decodeRealmObject(from realmObject: KikurageStateGraphObject) -> KikurageStateGraph {
        var kikurageStateGraph = KikurageStateGraph()
        kikurageStateGraph.mondayData = realmObject.mondayData
        kikurageStateGraph.tuesdayData = realmObject.tuesdayData
        kikurageStateGraph.wednesdayData = realmObject.wednesdayData
        kikurageStateGraph.thursdayData = realmObject.thursdayData
        kikurageStateGraph.fridayData = realmObject.fridayData
        kikurageStateGraph.saturdayData = realmObject.saturdayData
        kikurageStateGraph.sundayData = realmObject.sundayData
        return kikurageStateGraph
    }
    func encodeRealmObject(from response: KikurageStateGraph, expiredDate: Date) -> KikurageStateGraphObject {
        let kikurageStateGraphObject = KikurageStateGraphObject()
        kikurageStateGraphObject.mondayData = response.mondayData
        kikurageStateGraphObject.tuesdayData = response.tuesdayData
        kikurageStateGraphObject.wednesdayData = response.wednesdayData
        kikurageStateGraphObject.thursdayData = response.thursdayData
        kikurageStateGraphObject.fridayData = response.fridayData
        kikurageStateGraphObject.saturdayData = response.saturdayData
        kikurageStateGraphObject.sundayData = response.sundayData
        kikurageStateGraphObject.expiredDate = expiredDate
        return kikurageStateGraphObject
    }
}

// MARK: - Realm

typealias KikurageStateGraphRealmTuple = (data: KikurageStateGraphObject, documentId: String)

final class KikurageStateGraphObject: Object {
    // For realm
    dynamic var graphId: String = UUID().uuidString
    dynamic var expiredDate = Date()
    // Firebase response type
    dynamic var mondayData: TimeData?
    dynamic var tuesdayData: TimeData?
    dynamic var wednesdayData: TimeData?
    dynamic var thursdayData: TimeData?
    dynamic var fridayData: TimeData?
    dynamic var saturdayData: TimeData?
    dynamic var sundayData: TimeData?

    override static func primaryKey() -> String? {
        "graphId"
    }
}
