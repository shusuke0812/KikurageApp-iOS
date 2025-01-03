//
//  KikurageRecipeRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/21.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KDFirebase
import FirebaseFirestore
import Foundation

public struct KikurageRecipeRequest: FirestoreRequestProtocol {
    public init(
        kikurageUserID: String,
        documentID: String,
        imageStorageFullPaths: [String],
        body: [String : Any]? = nil
    ) {
        self.kikurageUserID = kikurageUserID
        self.documentID = documentID
        self.imageStorageFullPaths = imageStorageFullPaths
        self.body = body
    }
    public typealias Response = KikurageRecipe

    public let kikurageUserID: String
    public let documentID: String
    public let imageStorageFullPaths: [String]

    /// For using PUT method
    public var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(FirestoreCollectionName.users).document(kikurageUserID).collection(FirestoreCollectionName.recipes).document(documentID)
    }

    /// For using POST and GET method
    public var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        return db.collection(FirestoreCollectionName.users).document(kikurageUserID).collection(FirestoreCollectionName.recipes)
    }

    /// Using `self.buildBody()` to set this parameter
    public var body: [String: Any]? = [:]
}
