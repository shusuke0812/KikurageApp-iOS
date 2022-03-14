//
//  KikurageStateRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift
import RxSwift

protocol KikurageStateRepositoryProtocol {
    /// KikurageStateを読み込む
    /// - Parameters:
    ///   - productId: プロダクトキー（ドキュメントID）
    ///   - completion: 読み込み成功、失敗のハンドル
    func getKikurageState(productId: String, completion: @escaping (Result<KikurageState, ClientError>) -> Void)
    func getKikurageState(productId: String) -> Single<KikurageState>
    /// グラフデータを読み込む
    /// - Parameters:
    ///   - productId: プロダクトキー（ドキュメントID）
    ///   - completion: 読み込み成功、失敗のハンドル
    func getKikurageStateGraph(productId: String, completion: @escaping (Result<[(graph: KikurageStateGraph, documentId: String)], ClientError>) -> Void)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
}

// MARK: - Firebase Firestore

extension KikurageStateRepository {
    func getKikurageState(productId: String, completion: @escaping (Result<KikurageState, ClientError>) -> Void) {
        let db = Firestore.firestore()
        let docRef: DocumentReference = db.collection(Constants.FirestoreCollectionName.states).document(productId)

        docRef.getDocument { snapshot, error in
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
                var kikurageState: KikurageState = try Firestore.Decoder().decode(KikurageState.self, from: snapshotData)
                kikurageState.convertToStateType()
                completion(.success(kikurageState))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
    func getKikurageState(productId: String) -> Single<KikurageState> {
        return Single<KikurageState>.create { single in
            let db = Firestore.firestore()
            let docRef: DocumentReference = db.collection(Constants.FirestoreCollectionName.states).document(productId)
            
            docRef.getDocument { snapshot, error in
                if let error = error {
                    dump(error)
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                guard let snapshotData = snapshot?.data() else {
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                do {
                    var kikurageState: KikurageState = try Firestore.Decoder().decode(KikurageState.self, from: snapshotData)
                    kikurageState.convertToStateType()
                    single(.success(kikurageState))
                } catch {
                    single(.failure(ClientError.responseParseError(error)))
                }
            }
            return Disposables.create()
        }
    }
    func getKikurageStateGraph(productId: String, completion: @escaping (Result<[(graph: KikurageStateGraph, documentId: String)], ClientError>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef: CollectionReference = db.collection(Constants.FirestoreCollectionName.states).document(productId).collection(Constants.FirestoreCollectionName.graph)

        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            var graphs: [(graph: KikurageStateGraph, documentId: String)] = []
            do {
                for document in snapshot.documents {
                    let graph = try Firestore.Decoder().decode(KikurageStateGraph.self, from: document.data())
                    graphs.append((graph: graph, documentId: document.documentID))
                }
                completion(.success(graphs))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
}
