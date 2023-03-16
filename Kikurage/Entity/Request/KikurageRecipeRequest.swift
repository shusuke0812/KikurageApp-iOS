//
//  KikurageRecipeRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/21.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Firebase
import Foundation

struct KikurageRecipeRequest: FirestoreRequestProtocol {
    typealias Response = KikurageRecipe

    var kikurageUserID: String = ""
    var documentID: String = ""
    var imageStorageFullPaths: [String] = []

    /// For using PUT method
    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.recipes).document(documentID)
    }

    /// For using POST and GET method
    var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.recipes)
    }

    /// Using `self.buildBody()` to set this parameter
    var body: [String: Any]? = [:]
}
