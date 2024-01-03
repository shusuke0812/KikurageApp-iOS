//
//  KikurageCultivation.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import FirebaseFirestore

typealias KikurageCultivationTuple = (data: KikurageCultivation, documentID: String)

struct KikurageCultivation: Codable {
    var memo: String = ""
    var imageStoragePaths: [String] = []
    var viewDate: String = ""
    var createdAt: Timestamp?
    var updatedAt: Timestamp?

    enum CodingKeys: String, CodingKey {
        case memo
        case imageStoragePaths
        case viewDate
        case createdAt
        case updatedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(memo, forKey: .memo)
        try container.encode(imageStoragePaths, forKey: .imageStoragePaths)
        try container.encode(viewDate, forKey: .viewDate)
        if createdAt == nil {
            try container.encode(FieldValue.serverTimestamp(), forKey: .createdAt)
        }
        try container.encode(FieldValue.serverTimestamp(), forKey: .updatedAt)
    }
}
