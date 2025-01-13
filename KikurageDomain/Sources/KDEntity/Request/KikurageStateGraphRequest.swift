//
//  KikurageStateGraphRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/17.
//  Copyright © 2022 shusuke. All rights reserved.
//

import FirebaseFirestore
import KDFirebase

public struct KiikurageStateGraphRequest: FirestoreRequestProtocol {
    public typealias Response = KikurageStateGraph

    public var productID: String = ""

    public init(productID: String) {
        self.productID = productID
    }

    // TODO: documentReferenceはInfrastructure.Interceptorに定義する
    public var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        return db.collection(FirestoreCollectionName.states).document(productID).collection(FirestoreCollectionName.graph)
    }

    // MARK: Not using

    public var documentReference: DocumentReference?
    public var body: [String: Any]?
}
