//
//  KikurageUserRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/22.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift

protocol KikurageUserRepositoryProtocol {
    /// KikurageUserを読み込む（GET）
    func getKikurageUser(uid: String, completion: @escaping (Result<KikurageUser, Error>) -> Void)
}

class KikurageUserRepository: KikurageUserRepositoryProtocol {
}

extension KikurageUserRepository {
    func getKikurageUser(uid: String, completion: @escaping (Result<KikurageUser, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef: DocumentReference = db.collection("kikurageUsers").document(uid)
        
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
                let kikurageUser: KikurageUser = try Firestore.Decoder().decode(KikurageUser.self, from: snapshotData)
                completion(.success(kikurageUser))
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        }
    }
}
