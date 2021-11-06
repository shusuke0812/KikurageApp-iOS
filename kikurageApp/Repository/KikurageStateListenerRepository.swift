//
//  KikurageStateListenerRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/11/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Firebase

protocol KikurageStateListenerRepositoryProtocol {
    /// きくらげの状態を監視して更新を通知する
    func listenKikurageState(productKey: String, completion: @escaping (Result<KikurageState, ClientError>) -> Void)
}

class KikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol {
    private var kikurageStateListener: ListenerRegistration?

    deinit {
        kikurageStateListener?.remove()
    }
}

// MARK: - Firebase

extension KikurageStateListenerRepository {
    func listenKikurageState(productKey: String, completion: @escaping (Result<KikurageState, ClientError>) -> Void) {
        kikurageStateListener = Firestore.firestore().collection(Constants.FirestoreCollectionName.states).document(productKey).addSnapshotListener { snapshot, error in
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
                let kikurageState: KikurageState = try Firestore.Decoder().decode(KikurageState.self, from: snapshotData)
                completion(.success(kikurageState))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
}
