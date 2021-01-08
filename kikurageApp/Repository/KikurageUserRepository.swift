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
    /// きくらげユーザーを読み込む
    /// - Parameters:
    ///   - uid: ユーザーID
    ///   - completion: 読み込み成功、失敗のハンドル
    func getKikurageUser(uid: String, completion: @escaping (Result<KikurageUser, Error>) -> Void)
    /// きくらげユーザーを登録する
    /// - Parameters:
    ///   - kikurageUser: きくらげユーザー
    ///   - completion: 登録成功、失敗のハンドル
    func postKikurageUser(kikurageUser: KikurageUser, completion: @escaping (Result<DocumentReference, Error>) -> Void)
}

class KikurageUserRepository: KikurageUserRepositoryProtocol {
}
// MARK: - Firebase Firestore Method
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
    func postKikurageUser(kikurageUser: KikurageUser, completion: @escaping (Result<DocumentReference, Error>) -> Void) {
        let db = Firestore.firestore()
        var data: [String: Any]!
        do {
            data = try Firestore.Encoder().encode(kikurageUser)
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let ref: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(ref))
        }
    }
}
