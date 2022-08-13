//
//  Persistable.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/8/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import RealmSwift

protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
