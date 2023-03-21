//
//  KikurageStateGraphObject.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/21.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import RealmSwift

typealias KikurageStateGraphRealmTuple = (data: KikurageStateGraphObject, documentID: String)

final class KikurageStateGraphObject: Object {
    // For realm
    dynamic var graphID: String = UUID().uuidString
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
        "graphID"
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
