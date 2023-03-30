//
//  KikurageStateGraphObject.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/21.
//  Copyright © 2023 shusuke. All rights reserved.
//

//
//  Ref:
//  - relationship: https://www.mongodb.com/docs/realm/sdk/swift/model-data/define-model/relationships/
//  - ignore property: https://www.mongodb.com/docs/realm/sdk/swift/model-data/define-model/object-models/#ignore-a-property
//  - supported types: https://www.mongodb.com/docs/realm/sdk/swift/model-data/define-model/supported-types/
//  - does not support `struct`: https://www.mongodb.com/docs/realm/sdk/swift/model-data/define-model/object-models/#swift-structs
//  - [ important ] migration: https://www.mongodb.com/docs/realm/sdk/swift/model-data/change-an-object-model/
//

import Foundation
import RealmSwift

typealias KikurageStateGraphRealmTuple = (data: KikurageStateGraphObject, documentID: String)

final class KikurageStateGraphObject: KikurageRealmObject {
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
        expiredDate = Date()
    }

    override func update() {}
}

class TimeDataObject: KikurageRealmObject {
    @Persisted var date: Date
    @Persisted var temperature: Int
    @Persisted var humidity: Int

    override convenience init() {
        self.init()
        date = Date()
        temperature = 0
        humidity = 0
    }

    override func update() {}
}
