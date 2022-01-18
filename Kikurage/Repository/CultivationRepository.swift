//
//  CultivationRepository.swift
//  Kikurage
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
    ///   - kikurageCultivation: Firestoreへ保存する栽培記録データ
    ///   - completion: 投稿成功、失敗のハンドル
    func postCultivation(kikurageUserId: String, kikurageCultivation: KikurageCultivation, completion: @escaping (Result<DocumentReference, ClientError>) -> Void)
    /// 栽培画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    ///   - completion: 投稿成功、失敗のハンドル
    func postCultivationImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], ClientError>) -> Void)
    /// 栽培画像のStoragePathを更新する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - documentId: 栽培記録のドキュメントID
    ///   - imageStorageFullPaths: Storageに保存した画像のフルパス
    ///   - completion: 投稿成功、失敗のハンドル
    func putCultivationImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String], completion: @escaping (Result<[String], ClientError>) -> Void)
    /// 栽培記録を取得する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - completion: 投稿成功、失敗のハンドル
    func getCultivations(kikurageUserId: String, completion: @escaping (Result<Cultivations, ClientError>) -> Void)
}
class CultivationRepository: CultivationRepositoryProtocol {
    /// Storageへ保存するデータのメタデータ
    private let metaData: StorageMetadata

    init() {
        self.metaData = StorageMetadata()
        self.metaData.contentType = "image/jpeg"
    }
}

// MARK: - Firebase Firestore

extension CultivationRepository {
    func postCultivation(kikurageUserId: String, kikurageCultivation: KikurageCultivation, completion: @escaping (Result<DocumentReference, ClientError>) -> Void) {
        let db = Firestore.firestore()
        var data: [String: Any]!
        do {
            data = try Firestore.Encoder().encode(kikurageCultivation)
        } catch {
            completion(.failure(ClientError.parseError(error)))
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let documentReference: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.cultivations).addDocument(data: data) { error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.createError)))
            }
            dispatchGroup.leave()
        }
        // Firestoreにデータを登録した後、Storageに画像を投稿するためのPath用にドキュメントIDをコールバックする
        dispatchGroup.notify(queue: .main) {
            completion(.success(documentReference))
        }
    }
    func putCultivationImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String], completion: @escaping (Result<[String], ClientError>) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.cultivations).document(documentId)
        documentReference.updateData([
            "imageStoragePaths": imageStorageFullPaths
        ]) { error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.updateError)))
            } else {
                completion(.success(imageStorageFullPaths))
            }
        }
    }
    func getCultivations(kikurageUserId: String, completion: @escaping (Result<Cultivations, ClientError>) -> Void) {
        let db = Firestore.firestore()
        let collectionReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.cultivations)
        collectionReference.getDocuments { snapshot, error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(ClientError.apiError(.readError)))
                return
            }
            var cultivations: Cultivations = []
            do {
                for document in snapshot.documents {
                    let cultivation = try Firestore.Decoder().decode(KikurageCultivation.self, from: document.data())
                    cultivations.append((cultivation: cultivation, documentId: document.documentID))
                }
                completion(.success(cultivations))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
}

// MARK: - Firebase Storage

extension CultivationRepository {
    func postCultivationImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], ClientError>) -> Void) {
        // 画像保存後のフルパス格納用
        var imageStorageFullPaths: [String] = []
        // 直列処理（画像を１つずつ保存する）
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue(label: "com.shusuke.KikurageApp.upload_cultivation_images_queue")
        // エラー結果を保持する変数
        var resultError: Error?
        dispatchQueue.async {
            for (i, imageData) in zip(imageData.indices, imageData) {
                guard let imageData = imageData else {
                    dispatchSemaphore.signal()
                    return
                }
                let fileName: String = DateHelper.formatToStringForImageData(date: Date()) + "_\(i).jpeg"
                let storageReference = Storage.storage().reference().child(imageStoragePath + fileName)
                _ = storageReference.putData(imageData, metadata: self.metaData) { _, error in
                    if let error = error {
                        resultError = error
                        dispatchSemaphore.signal()
                        return
                    }
                    imageStorageFullPaths.append(storageReference.fullPath)
                    dispatchSemaphore.signal()
                }
                dispatchSemaphore.wait()
            }
            DispatchQueue.main.async {
                if let resultError = resultError {
                    dump(resultError)
                    completion(.failure(ClientError.apiError(.createError)))
                } else {
                    completion(.success(imageStorageFullPaths))
                }
            }
        }
    }
}
