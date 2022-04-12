//
//  FirebaseRequestProtocol.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreRequestProtocol {
    associatedtype Response: Codable

    var documentReference: DocumentReference? { get }
    var collectionReference: CollectionReference? { get }
    
    var body: [String : Any]? { get set }
}