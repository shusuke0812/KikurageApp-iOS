//
//  KikurageCultivation.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import FirebaseFirestore
import Foundation

public typealias KikurageCultivationTuple = (data: KikurageCultivation, documentID: String)

public struct KikurageCultivation: Codable {
    public var memo: String = ""
    public var imageStoragePaths: [String] = []
    public var viewDate: String = ""

    public enum CodingKeys: String, CodingKey {
        case memo
        case imageStoragePaths
        case viewDate
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(memo, forKey: .memo)
        try container.encode(imageStoragePaths, forKey: .imageStoragePaths)
        try container.encode(viewDate, forKey: .viewDate)
    }
}
