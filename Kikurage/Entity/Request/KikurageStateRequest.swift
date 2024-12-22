//
//  KikurageStateRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import FirebaseFirestore
import Foundation

struct KikurageStateRequest: FirestoreRequestProtocol {
    typealias Response = KikurageState

    var productID: String = ""

    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.states).document(productID)
    }

    // MARK: Not using

    var collectionReference: CollectionReference?
    var body: [String: Any]?
}
