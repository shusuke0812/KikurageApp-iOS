//
//  KikurageStateListenerRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/11/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import FirebaseFirestore
import RxSwift

protocol KikurageStateListenerRepositoryProtocol {
    /// きくらげの状態を監視して更新を通知する
    func listenKikurageState(productKey: String, completion: @escaping (Result<KikurageState, ClientError>) -> Void)
    func listenKikurageState(productKey: String) -> Observable<KikurageState>
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

    func listenKikurageState(productKey: String) -> Observable<KikurageState> {
        Observable<KikurageState>.create { [weak self] observer in
            let db = Firestore.firestore()
            let docRef: DocumentReference = db.collection(Constants.FirestoreCollectionName.states).document(productKey)

            self?.kikurageStateListener = docRef.addSnapshotListener { snapshot, error in
                if let error = error {
                    dump(error)
                    observer.onError(ClientError.apiError(.readError))
                    return
                }
                guard let snapshotData = snapshot?.data() else {
                    observer.onError(ClientError.apiError(.readError))
                    return
                }
                do {
                    let kikurageState: KikurageState = try Firestore.Decoder().decode(KikurageState.self, from: snapshotData)
                    observer.onNext(kikurageState)
                } catch {
                    observer.onError(ClientError.responseParseError(error))
                }
            }
            return Disposables.create()
        }
    }
}
