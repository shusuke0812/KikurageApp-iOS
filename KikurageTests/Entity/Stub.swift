//
//  Stub.swift
//  KikurageTests
//
//  Created by Shusuke Ota on 2021/12/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
@testable import Kikurage

enum Stub {
    static let kikurageState = KikurageState(temperature: 20,
                                             humidity: 50,
                                             message: "test message",
                                             judge: "test judge",
                                             advice: "test advice")
    static let kikurageStateGraph = KikurageUser(productKey: "test",
                                                 kikurageName: "test",
                                                 cultivationStartDate: Date(),
                                                 stateRef: nil,
                                                 createdAt: nil,
                                                 updatedAt: nil)
}
