//
//  Persistable.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/8/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmCodable {
    associatedtype RealmObject: RealmSwift.Object
    associatedtype Response: Codable
    func decodeRealmObject(from realmObject: RealmObject) -> Response
    func encodeRealmObject(from response: Response, expiredDate: Date) -> RealmObject
}
