//
//  FirestoreRequestProtocol.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Firebase
import Foundation

protocol FirestoreRequestProtocol {
    associatedtype Response: Codable

    var documentReference: DocumentReference? { get }
    var collectionReference: CollectionReference? { get }

    var body: [String: Any]? { get set }

    func buildBody(from data: Self.Response) -> [String: Any]?
}

extension FirestoreRequestProtocol {
    func buildBody(from data: Self.Response) -> [String: Any]? {
        do {
            return try Firestore.Encoder().encode(data)
        } catch {
            return nil
        }
    }
}
