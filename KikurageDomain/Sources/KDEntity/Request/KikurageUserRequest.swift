//
//  KikurageUserRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KDFirebase
import FirebaseFirestore

public struct KikurageUserRequest: FirestoreRequestProtocol {
    public init(
        uid: String,
        body: [String : Any]? = nil,
        collectionReference: CollectionReference? = nil
    ) {
        self.uid = uid
        self.body = body
        self.collectionReference = collectionReference
    }

    public typealias Response = KikurageUser

    public let uid: String

    public var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(FirestoreCollectionName.users).document(uid)
    }

    public var body: [String: Any]?

    // MARK: Not using

    public var collectionReference: CollectionReference?
}
