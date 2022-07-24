//
//  KikurageUser.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct KikurageUser: Codable {
    var productKey: String = ""
    var kikurageName: String = ""
    var cultivationStartDate = Date()
    var stateRef: DocumentReference?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?

    enum CodingKeys: String, CodingKey {
        case productKey
        case kikurageName
        case cultivationStartDate
        case stateRef
        case createdAt
        case updatedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productKey, forKey: .productKey)
        try container.encode(kikurageName, forKey: .kikurageName)
        try container.encode(cultivationStartDate, forKey: .cultivationStartDate)
        try container.encode(stateRef, forKey: .stateRef)
        if createdAt == nil {
            try container.encode(FieldValue.serverTimestamp(), forKey: .createdAt)
        }
        try container.encode(FieldValue.serverTimestamp(), forKey: .updatedAt)
    }
}
