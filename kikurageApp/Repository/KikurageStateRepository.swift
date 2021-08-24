//
//  KikurageStateRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift

protocol KikurageStateRepositoryProtocol {
    /// KikurageStateを読み込む
    /// - Parameters:
    ///   - productId: プロダクトキー（ドキュメントID）
    ///   - completion: 読み込み成功、失敗のハンドル
    func getKikurageState(productId: String, completion: @escaping (Result<KikurageState, Error>) -> Void)
    /// グラフデータを読み込む
    /// - Parameters:
    ///   - productId: プロダクトキー（ドキュメントID）
    ///   - completion: 読み込み成功、失敗のハンドル
    func getKikurageStateGraph(productId: String, completion: @escaping (Result<[(graph: KikurageStateGraph, documentId: String)], Error>) -> Void)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
}
// MARK: - Firebase Firestore
extension KikurageStateRepository {
    func getKikurageState(productId: String, completion: @escaping (Result<KikurageState, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef: DocumentReference = db.collection(Constants.FirestoreCollectionName.states).document(productId)

        docRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshotData = snapshot?.data() else {
                completion(.failure(NetworkError.unknown))
                return
            }
            do {
                let kikurageState: KikurageState = try Firestore.Decoder().decode(KikurageState.self, from: snapshotData)
                completion(.success(kikurageState))
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    func getKikurageStateGraph(productId: String, completion: @escaping (Result<[(graph: KikurageStateGraph, documentId: String)], Error>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef: CollectionReference = db.collection(Constants.FirestoreCollectionName.states).document(productId).collection(Constants.FirestoreCollectionName.graph)

        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(NetworkError.unknown))
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
                completion(.failure(error))
            }
        }
    }
}
