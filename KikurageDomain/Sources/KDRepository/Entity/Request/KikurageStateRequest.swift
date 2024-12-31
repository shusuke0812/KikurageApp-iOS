//
//  KikurageStateRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KDFirebase
import FirebaseFirestore

public struct KikurageStateRequest: FirestoreRequestProtocol {
    public typealias Response = KikurageState

    public var productID: String = ""

    // TODO: documentReferenceはInfrastructure.Interceptorに定義する
    public var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(FirestoreCollectionName.states).document(productID)
    }

    // MARK: Not using

    public var collectionReference: CollectionReference?
    public var body: [String: Any]?
}
