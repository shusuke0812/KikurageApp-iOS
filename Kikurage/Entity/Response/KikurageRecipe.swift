//
//  KikurageRecipe.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import Firebase

typealias KikurageRecipeTuple = (data: KikurageRecipe, documentId: String)

struct KikurageRecipe: Codable {
    var name: String = ""
    var memo: String = ""
    var imageStoragePaths: [String] = []
    var cookDate: String = ""
    var createdAt: Timestamp?
    var updatedAt: Timestamp?

    enum CodingKeys: String, CodingKey {
        case name
        case memo
        case imageStoragePaths
        case cookDate
        case createdAt
        case updatedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(memo, forKey: .memo)
        try container.encode(imageStoragePaths, forKey: .imageStoragePaths)
        try container.encode(cookDate, forKey: .cookDate)
        if createdAt == nil {
            try container.encode(FieldValue.serverTimestamp(), forKey: .createdAt)
        }
        try container.encode(FieldValue.serverTimestamp(), forKey: .updatedAt)
    }
}
