//
//  KikurageUserRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import Firebase

struct KikurageUserRequest: FirestoreRequestProtocol {
    typealias Response = KikurageUser

    var uid: String = ""

    var documentReference: DocumentReference? {
        let db = Firestore.firestore()
        return db.collection(Constants.FirestoreCollectionName.users).document(uid)
    }

    // MARK: Not using

    var collectionReference: CollectionReference?
    var body: [String: Any]?
}
