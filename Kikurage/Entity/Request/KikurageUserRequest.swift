//
//  KikurageUserRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import FirebaseFirestore
import Foundation

struct KikurageUserRequest: FirestoreRequestProtocol {
    typealias Response = KikurageUser

    var uid: String = ""

    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(uid)
    }

    var body: [String: Any]? = [:]

    // MARK: Not using

    var collectionReference: CollectionReference?
}
