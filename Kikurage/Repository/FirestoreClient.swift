//
//  FirebaseClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

protocol FirestoreClientProtocol {
    func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void)
    func getDocumentsRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<[(data: T.Response, documentId: String)], ClientError>) -> Void)
    func listenDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) -> ListenerRegistration?
    func postDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, ClientError>) -> Void)
    func postDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<DocumentReference, ClientError>) -> Void)
    func putDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, ClientError>) -> Void)

    func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<T.Response>
    func getDocumentsRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<[T.Response]>
}

struct FirestoreClient: FirestoreClientProtocol {
    // MARK: - GET

    func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) {
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
    func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<T.Response> {
        Single<T.Response>.create { single in
            request.documentReference?.getDocument { snapshot, error in
                if error != nil {
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                guard let snapshotData = snapshot?.data() else {
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                do {
                    let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: snapshotData)
                    single(.success(firebaseResponse))
                } catch {
                    single(.failure(ClientError.responseParseError(error)))
                }
            }
            return Disposables.create()
        }
    }
    func getDocumentsRequest<T>(_ request: T, completion: @escaping (Result<[(data: T.Response, documentId: String)], ClientError>) -> Void) where T: FirestoreRequestProtocol {
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
            var firebaseResponses: [(data: T.Response, documentId: String)] = []
            do {
                for document in snapshot.documents {
                    let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: document.data())
                    firebaseResponses.append((data: firebaseResponse, documentId: document.documentID))
                }
                completion(.success(firebaseResponses))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
    func getDocumentsRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<[T.Response]> {
        Single<[T.Response]>.create { single in
            request.collectionReference?.getDocuments { snapshot, error in
                if error != nil {
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                guard let snapshot = snapshot else {
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                var firebaseResponses: [T.Response] = []
                do {
                    for document in snapshot.documents {
                        let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: document.data())
                        firebaseResponses.append(firebaseResponse)
                    }
                    single(.success(firebaseResponses))
                } catch {
                    single(.failure(ClientError.responseParseError(error)))
                }
            }
            return Disposables.create()
        }
    }
    func listenDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) -> ListenerRegistration? {
        request.documentReference?.addSnapshotListener { snapshot, error in
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

    func postDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, ClientError>) -> Void) {
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
    func postDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<DocumentReference, ClientError>) -> Void) {
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

    // MARK: - PUT

    func putDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, ClientError>) -> Void) {
        guard let body = request.body else {
            completion(.failure(ClientError.unknown))
            return
        }
        request.documentReference?.updateData(body) { error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.updateError)))
            } else {
                completion(.success(()))
            }
        }
    }
}
