//
//  FirebaseClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseClientProtocol {
    func getDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void)
    func getDocumentsRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<[T.Response], ClientError>) -> Void)
}

struct FirebaseClient: FirebaseClientProtocol {
    func getDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) {
        request.documentReference?.getDocument { snapshot, error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            guard let snapshotData = snapshot?.data() else {
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            do {
                let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: snapshotData)
                completion(.success(firebaseResponse))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
    func getDocumentsRequest<T>(_ request: T, completion: @escaping (Result<[T.Response], ClientError>) -> Void) where T: FirebaseRequestProtocol {
        request.collectionReference?.getDocuments { snapshot, error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            var firebaseReponses: [T.Response] = []
            do {
                for document in snapshot.documents {
                    let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: document.data())
                    firebaseReponses.append(firebaseResponse)
                }
                completion(.success(firebaseReponses))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
}
