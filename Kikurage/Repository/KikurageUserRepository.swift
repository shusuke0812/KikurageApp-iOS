//
//  KikurageUserRepository.swift
//  Kikurage
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
    func getKikurageUser(uid: String, completion: @escaping (Result<KikurageUser, ClientError>) -> Void)
    /// きくらげユーザーを登録する
    /// - Parameters:
    ///   - uid: ユーザーID
    ///   - kikurageUser: きくらげユーザー
    ///   - completion: 登録成功、失敗のハンドル
    func postKikurageUser(uid: String, kikurageUser: KikurageUser, completion: @escaping (Result<Void, ClientError>) -> Void)
}

class KikurageUserRepository: KikurageUserRepositoryProtocol {
}

// MARK: - Firebase Firestore

extension KikurageUserRepository {
    func getKikurageUser(uid: String, completion: @escaping (Result<KikurageUser, ClientError>) -> Void) {
        let db = Firestore.firestore()
        let docRef: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(uid)

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
                let kikurageUser: KikurageUser = try Firestore.Decoder().decode(KikurageUser.self, from: snapshotData)
                completion(.success(kikurageUser))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
    func postKikurageUser(uid: String, kikurageUser: KikurageUser, completion: @escaping (Result<Void, ClientError>) -> Void) {
        let db = Firestore.firestore()
        var data: [String: Any]!
        do {
            data = try Firestore.Encoder().encode(kikurageUser)
        } catch {
            completion(.failure(ClientError.parseError(error)))
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        db.collection(Constants.FirestoreCollectionName.users).document(uid).setData(data) { error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.createError)))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
}
