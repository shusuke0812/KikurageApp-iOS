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
    /// KikurageStateを読み込む（GET）
    /// - Parameters:
    ///   - uid: プロダクトID
    func getKikurageState(uid: String, completion: @escaping (Result<KikurageState, Error>) -> Void)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
}

extension KikurageStateRepository {
    func getKikurageState(uid: String, completion: @escaping (Result<KikurageState, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef: DocumentReference = db.collection("kikurageStates").document(uid)

        docRef.getDocument { (snapshot, error) in
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
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        }
    }
}
