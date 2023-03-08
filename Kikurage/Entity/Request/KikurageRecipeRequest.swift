//
//  KikurageRecipeRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/21.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import Firebase

struct KikurageRecipeRequest: FirestoreRequestProtocol {
    typealias Response = KikurageRecipe
    
    var kikurageUserId: String = ""
    var documentId: String = ""
    var imageStorageFullPaths: [String] = []
    
    /// For using PUT method
    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes).document(documentId)
    }
    /// For using POST and GET method
    var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes)
    }
    
    /// Using `self.buildBody()` to set this parameter
    var body: [String : Any]? = [:]
}
