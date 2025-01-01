//
//  File.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import FirebaseFirestore
import Foundation
import RxSwift

public protocol FirestoreClientProtocol {
    func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, FirebaseClientError>) -> Void)
    func getDocumentsRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<[(data: T.Response, documentID: String)], FirebaseClientError>) -> Void)
    func postDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, FirebaseClientError>) -> Void)
    func postDocumentWithGetReferenceRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<DocumentReference, FirebaseClientError>) -> Void)
    func putDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, FirebaseClientError>) -> Void)
}

public protocol RxFirestoreClientProtocol {
    func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<T.Response>
    func getDocumentsRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<[(data: T.Response, documentID: String)]>
}

public struct FirestoreClient: FirestoreClientProtocol {
    public init() {}

    // MARK: - GET

    public func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, FirebaseClientError>) -> Void) {
        request.documentReference?.getDocument { snapshot, error in
            if let error = error {
                dump(error)
                completion(.failure(FirebaseClientError.apiError(.readError)))
                return
            }
            guard let snapshotData = snapshot?.data() else {
                completion(.failure(FirebaseClientError.apiError(.readError)))
                return
            }
            do {
                let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: snapshotData)
                completion(.success(firebaseResponse))
            } catch {
                completion(.failure(FirebaseClientError.responseParseError(error)))
            }
        }
    }

    public func getDocumentsRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<[(data: T.Response, documentID: String)], FirebaseClientError>) -> Void) {
        request.collectionReference?.getDocuments { snapshot, error in
            if let error = error {
                dump(error)
                completion(.failure(FirebaseClientError.apiError(.readError)))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(FirebaseClientError.apiError(.readError)))
                return
            }
            var firebaseResponses: [(data: T.Response, documentID: String)] = []
            do {
                for document in snapshot.documents {
                    let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: document.data())
                    firebaseResponses.append((data: firebaseResponse, documentID: document.documentID))
                }
                completion(.success(firebaseResponses))
            } catch {
                completion(.failure(FirebaseClientError.responseParseError(error)))
            }
        }
    }

    // MARK: - POST

    public func postDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, FirebaseClientError>) -> Void) {
        guard let body = request.body else {
            completion(.failure(FirebaseClientError.unknown))
            return
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        request.documentReference?.setData(body) { error in
            if let error = error {
                dump(error)
                completion(.failure(FirebaseClientError.apiError(.createError)))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }

    /// In case of saving data with using document ID into Firebase Storage
    public func postDocumentWithGetReferenceRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<DocumentReference, FirebaseClientError>) -> Void) {
        guard let body = request.body, let collectionReference = request.collectionReference else {
            completion(.failure(FirebaseClientError.unknown))
            return
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let documentReference: DocumentReference = collectionReference.addDocument(data: body) { error in
            if let error = error {
                dump(error)
                completion(.failure(FirebaseClientError.apiError(.createError)))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(documentReference))
        }
    }

    // MARK: - PUT

    public func putDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<Void, FirebaseClientError>) -> Void) {
        guard let body = request.body else {
            completion(.failure(FirebaseClientError.unknown))
            return
        }
        request.documentReference?.updateData(body) { error in
            if let error = error {
                dump(error)
                completion(.failure(FirebaseClientError.apiError(.updateError)))
            } else {
                completion(.success(()))
            }
        }
    }
}

public struct RxFirestoreClient: RxFirestoreClientProtocol {
    public init() {}

    // MARK: - GET

    public func getDocumentRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<T.Response> {
        Single<T.Response>.create { single in
            request.documentReference?.getDocument { snapshot, error in
                if error != nil {
                    single(.failure(FirebaseClientError.apiError(.readError)))
                    return
                }
                guard let snapshotData = snapshot?.data() else {
                    single(.failure(FirebaseClientError.apiError(.readError)))
                    return
                }
                do {
                    let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: snapshotData)
                    single(.success(firebaseResponse))
                } catch {
                    single(.failure(FirebaseClientError.responseParseError(error)))
                }
            }
            return Disposables.create()
        }
    }

    public func getDocumentsRequest<T: FirestoreRequestProtocol>(_ request: T) -> Single<[(data: T.Response, documentID: String)]> {
        Single<[(data: T.Response, documentID: String)]>.create { single in
            request.collectionReference?.getDocuments { snapshot, error in
                if error != nil {
                    single(.failure(FirebaseClientError.apiError(.readError)))
                    return
                }
                guard let snapshot = snapshot else {
                    single(.failure(FirebaseClientError.apiError(.readError)))
                    return
                }
                var firebaseResponses: [(data: T.Response, documentID: String)] = []
                do {
                    for document in snapshot.documents {
                        let firebaseResponse = try Firestore.Decoder().decode(T.Response.self, from: document.data())
                        firebaseResponses.append((data: firebaseResponse, documentID: document.documentID))
                    }
                    single(.success(firebaseResponses))
                } catch {
                    single(.failure(FirebaseClientError.responseParseError(error)))
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - POST

    // MARK: - PUT
}
