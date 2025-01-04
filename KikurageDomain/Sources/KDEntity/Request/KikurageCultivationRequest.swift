//
//  KikurageCultivationRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KDFirebase
import FirebaseFirestore
import Foundation

public struct KikurageCultivationRequest: FirestoreRequestProtocol {
    public typealias Response = KikurageCultivation

    public var kikurageUserID: String = ""
    public var documentID: String = ""
    public var imageStorageFullPaths: [String] = []
    
    public init(kikurageUserID: String) {
        self.kikurageUserID = kikurageUserID
    }

    /// For using PUT method
    public var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(FirestoreCollectionName.users).document(kikurageUserID).collection(FirestoreCollectionName.cultivations).document(documentID)
    }

    /// For using POST and GET method
    public var collectionReference: CollectionReference? {
        let db = Firestore.firestore()
        return db.collection(FirestoreCollectionName.users).document(kikurageUserID).collection(FirestoreCollectionName.cultivations)
    }

    /// Using `self.buildBody()` to set this parameter
    public var body: [String: Any]? = [:]
}
