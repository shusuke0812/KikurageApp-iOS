//
//  KikurageStateGraphObject.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/21.
//  Copyright © 2023 shusuke. All rights reserved.
//

/**
 * Ref:
 * - relationship: https://www.mongodb.com/docs/realm/sdk/swift/model-data/define-model/relationships/
 * - ignore property: https://www.mongodb.com/docs/realm/sdk/swift/model-data/define-model/object-models/#ignore-a-property
 */

import Foundation
import RealmSwift

typealias KikurageStateGraphRealmTuple = (data: KikurageStateGraphObject, documentID: String)

final class KikurageStateGraphObject: Object {
    // For realm
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var expiredDate: Date
    // Firebase response type
    @Persisted var mondayData: TimeDataObject?
    @Persisted var tuesdayData: TimeDataObject?
    @Persisted var wednesdayData: TimeDataObject?
    @Persisted var thursdayData: TimeDataObject?
    @Persisted var fridayData: TimeDataObject?
    @Persisted var saturdayData: TimeDataObject?
    @Persisted var sundayData: TimeDataObject?
    
    override convenience init() {
        self.init()
        self.expiredDate = Date()
    }
}

class TimeDataObject: Object {
    @Persisted var date: Date
    @Persisted var temperature: Int
    @Persisted var humidity: Int
    
    override convenience init() {
        self.init()
        self.date = Date()
        self.temperature = 0
        self.humidity = 0
    }
}
