//
//  FirestoreListenClient.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import FirebaseFirestore
import Foundation

public protocol FirestoreListenClientProtocol {
    func listenDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, FirebaseClientError>) -> Void)
}

public class FirestoreListenClient: FirestoreListenClientProtocol {
    private var listener: ListenerRegistration?
    
    public init() {}
    
    deinit {
        listener?.remove()
    }
    
    public func listenDocumentRequest<T: FirestoreRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, FirebaseClientError>) -> Void) {
        listener = request.documentReference?.addSnapshotListener { snapshot, error in
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
                let apiResponse = try Firestore.Decoder().decode(T.Response.self, from: snapshotData)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(FirebaseClientError.responseParseError(error)))
            }
        }
    }
}
