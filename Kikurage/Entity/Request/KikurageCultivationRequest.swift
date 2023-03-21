//
//  CultivationRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Firebase
import Foundation

struct KikurageCultivationRequest: FirestoreRequestProtocol {
    typealias Response = KikurageCultivation

    var kikurageUserID: String = ""
    var documentID: String = ""
    var imageStorageFullPaths: [String] = []

    /// For using PUT method
    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.cultivations).document(documentID)
    }

    /// For using POST and GET method
    var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.cultivations)
    }

    /// Using `self.buildBody()` to set this parameter
    var body: [String: Any]? = [:]
}
