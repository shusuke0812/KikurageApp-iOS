//
//  CultivationRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol CultivationRepositoryProtocol {
    /// 栽培記録を投稿する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - cultivation: Firestoreへ保存する栽培記録データ
    ///   - completion: 投稿成功、失敗のハンドル
    func postCultivation(kikurageUserId: String,
                         kikurageCultivation: KikurageCultivation,
                         completion: @escaping (Result<DocumentReference, Error>) -> Void)
}
class CultivationRepository: CultivationRepositoryProtocol {
}
extension CultivationRepository {
    func postCultivation(kikurageUserId: String,
                         kikurageCultivation: KikurageCultivation,
                         completion: @escaping (Result<DocumentReference, Error>) -> Void) {
        let db = Firestore.firestore()
        var data: [String: Any]!
        do {
            data = try Firestore.Encoder().encode(kikurageCultivation)
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let documentReference: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.cultivations).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            }
            dispatchGroup.leave()
        }
        // Firestoreにデータを登録した後、Storageに画像を投稿するためのPath用にドキュメントIDをコールバックする
        dispatchGroup.notify(queue: .main) {
            completion(.success(documentReference))
        }
    }
}
