//
//  KikurageRecipe.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import FirebaseFirestore
import Foundation

public typealias KikurageRecipeTuple = (data: KikurageRecipe, documentID: String)

public struct KikurageRecipe: Codable {
    public var name: String = ""
    public var memo: String = ""
    public var imageStoragePaths: [String] = []
    public var cookDate: String = ""
    public var createdAt: Timestamp?
    public var updatedAt: Timestamp?
    
    public init() {}

    public enum CodingKeys: String, CodingKey {
        case name
        case memo
        case imageStoragePaths
        case cookDate
        case createdAt
        case updatedAt
    }

    public func encode(to encoder: Encoder) throws {
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
