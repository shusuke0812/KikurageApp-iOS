//
//  KikurageStateListenerRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/11/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KDFirebase
import KDEntity
import RxSwift

public protocol KikurageStateListenerRepositoryProtocol {
    /// きくらげの状態を監視して更新を通知する
    func listenKikurageState(productKey: String, completion: @escaping (Result<KikurageState, FirebaseClientError>) -> Void)
    func listenKikurageState(productKey: String) -> Observable<KikurageState>
}

public class KikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol {
    private var firestoreListenClient: FirestoreListenClientProtocol

    public init(firestoreListenClient: FirestoreListenClientProtocol = FirestoreListenClient()) {
        self.firestoreListenClient = firestoreListenClient
    }
}

// MARK: - Firebase

extension KikurageStateListenerRepository {
    public func listenKikurageState(productKey: String, completion: @escaping (Result<KikurageState, FirebaseClientError>) -> Void) {
        let request = KikurageStateRequest(productID: productKey)
        firestoreListenClient.listenDocumentRequest(request) { result in
            switch result {
            case .success(let state):
                completion(.success(state))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func listenKikurageState(productKey: String) -> Observable<KikurageState> {
        Observable<KikurageState>.create { [weak self] observer in
            let request = KikurageStateRequest(productID: productKey)
            self?.firestoreListenClient.listenDocumentRequest(request) { result in
                switch result {
                case  .success(let state):
                    observer.onNext(state)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
