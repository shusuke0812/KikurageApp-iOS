//
//  FirebaseClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreClientProtocol {
    func getDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void)
    func getDocumentsRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<[T.Response], ClientError>) -> Void)
    func listenDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) -> ListenerRegistration?
    func postDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<Void, ClientError>) -> Void)
    func postDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<DocumentReference, ClientError>) -> Void)
}

protocol FirebaseStorageClientProtocol {}

struct FirebaseClient: FirestoreClientProtocol, FirebaseStorageClientProtocol {
    // MARK: - GET

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
    func listenDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) -> ListenerRegistration? {
        return request.documentReference?.addSnapshotListener { snapshot, error in
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
                let apiResponse = try Firestore.Decoder().decode(T.Response.self, from: snapshotData)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
    
    // MARK: - POST
    
    func postDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<Void, ClientError>) -> Void) {
        guard let body = request.body else {
            completion(.failure(ClientError.unknown))
            return
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        request.documentReference?.setData(body) { error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.createError)))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    /// In case of saving data with using document ID into Firebase Storage
    func postDocumentRequest<T: FirebaseRequestProtocol>(_ request: T, completion: @escaping (Result<DocumentReference, ClientError>) -> Void) {
        guard let body = request.body, let collectionReference = request.collectionReference else {
            completion(.failure(ClientError.unknown))
            return
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let documentReference: DocumentReference = collectionReference.addDocument(data: body) { error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.createError)))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(documentReference))
        }
    }
}
