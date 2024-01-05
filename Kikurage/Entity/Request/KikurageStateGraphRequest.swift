//
//  KikurageStateGraphRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/17.
//  Copyright © 2022 shusuke. All rights reserved.
//

import FirebaseFirestore
import Foundation

struct KiikurageStateGraphRequest: FirestoreRequestProtocol {
    typealias Response = KikurageStateGraph

    var productID: String = ""

    var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.states).document(productID).collection(Constants.FirestoreCollectionName.graph)
    }

    // MARK: Not using

    var documentReference: DocumentReference?
    var body: [String: Any]?
}
