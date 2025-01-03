//
//  KikurageUser.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDFirebase
import Foundation

public struct KikurageUser: Codable {
    public var productKey: String = ""
    public var kikurageName: String = ""
    public var cultivationStartDate = Date()

    public enum CodingKeys: String, CodingKey {
        case productKey
        case kikurageName
        case cultivationStartDate
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productKey, forKey: .productKey)
        try container.encode(kikurageName, forKey: .kikurageName)
        try container.encode(cultivationStartDate, forKey: .cultivationStartDate)
    }
}
