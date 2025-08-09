//
//  KikurageUser.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import FirebaseFirestore
import Foundation
import KDFirebase

public struct KikurageUser: Codable {
    public var productKey: String
    public var kikurageName: String
    public var cultivationStartDate: Date

    private var stateRef: DocumentReference?

    public init(
        productKey: String,
        kikurageName: String,
        cultivationStartDate: Date = Date()
    ) {
        self.productKey = productKey
        self.kikurageName = kikurageName
        self.cultivationStartDate = cultivationStartDate
    }

    public enum CodingKeys: String, CodingKey {
        case productKey
        case kikurageName
        case cultivationStartDate
    }

    public mutating func setStateRef(productKey: String) {
        stateRef = Firestore.firestore().document("/" + FirestoreCollectionName.states + "/\(productKey)")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productKey, forKey: .productKey)
        try container.encode(kikurageName, forKey: .kikurageName)
        try container.encode(cultivationStartDate, forKey: .cultivationStartDate)
    }
}
