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
    /// 栽培画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    func postCultivationImages(imageData: [Data?], imageStoragePath: String,
                               completion: @escaping (Result<String, Error>) -> Void)
}
class CultivationRepository: CultivationRepositoryProtocol {
    // DateHelper
    private let dateHelper: DateHelper
    // Storageへ保存するデータのメタデータ
    private let metaData: StorageMetadata
    
    init() {
        self.dateHelper = DateHelper()
        self.metaData = StorageMetadata()
        self.metaData.contentType = "image/jpeg"
    }
}
// MARK: - Firebase Firestore Method
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
// MARK: - Firebase Storage Method
extension CultivationRepository {
    func postCultivationImages(imageData: [Data?], imageStoragePath: String,
                               completion: @escaping (Result<String, Error>) -> Void) {
        let dispathcGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "PostImageTask")
        for (i, imageData) in zip(imageData.indices, imageData) {
            guard let imageData = imageData else { return }
            dispathcGroup.enter()
            dispatchQueue.async(group: dispathcGroup) {
                let fileName: String = self.dateHelper.formatToStringForImageData(date: Date()) + "_\(i).jpeg"
                let storageReference = Storage.storage().reference().child(imageStoragePath + fileName)
                _ = storageReference.putData(imageData, metadata: self.metaData) { (metaData, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    dispathcGroup.leave()
                }
            }
        }
        dispathcGroup.notify(queue: .main) {
            completion(.success("DEBUG: 画像の保存に成功しました"))
        }
    }
}
