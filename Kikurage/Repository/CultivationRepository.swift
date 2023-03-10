//
//  CultivationRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import RxSwift
import UIKit

protocol CultivationRepositoryProtocol {
    /// 栽培記録を投稿する
    func postCultivation(request: KikurageCultivationRequest, completion: @escaping (Result<DocumentReference, ClientError>) -> Void)
    func postCultivation(kikurageUserID: String, kikurageCultivation: KikurageCultivation) -> Single<DocumentReference>
    /// 栽培画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    ///   - completion: 投稿成功、失敗のハンドル
    func postCultivationImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], ClientError>) -> Void)
    func postCultivationImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]>
    /// 栽培画像のStoragePathを更新する
    func putCultivationImage(request: KikurageCultivationRequest, completion: @escaping (Result<Void, ClientError>) -> Void)
    func putCultivationImage(kikurageUserID: String, documentID: String, imageStorageFullPaths: [String]) -> Single<[String]>
    /// 栽培記録を取得する
    func getCultivations(request: KikurageCultivationRequest, completion: @escaping (Result<[KikurageCultivationTuple], ClientError>) -> Void)
    func getCultivations(request: KikurageCultivationRequest) -> Single<[KikurageCultivationTuple]>
}

class CultivationRepository: CultivationRepositoryProtocol {
    private let firestoreClient: FirestoreClientProtocol
    private let rxFirestoreClient: RxFirestoreClientProtocol
    /// Storageへ保存するデータのメタデータ
    private let metaData: StorageMetadata

    init(firestoreClient: FirestoreClientProtocol = FirestoreClient(), rxFirestoreClient: RxFirestoreClientProtocol = RxFirestoreClient()) {
        self.firestoreClient = firestoreClient
        self.rxFirestoreClient = rxFirestoreClient

        metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
    }
}

// MARK: - Firebase Firestore

extension CultivationRepository {
    func postCultivation(request: KikurageCultivationRequest, completion: @escaping (Result<DocumentReference, ClientError>) -> Void) {
        firestoreClient.postDocumentWithGetReferenceReques(request) { result in
            switch result {
            case .success(let documentReference):
                completion(.success(documentReference))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func postCultivation(kikurageUserID: String, kikurageCultivation: KikurageCultivation) -> Single<DocumentReference> {
        Single<DocumentReference>.create { single in
            let db = Firestore.firestore()
            var data: [String: Any]!
            do {
                data = try Firestore.Encoder().encode(kikurageCultivation)
            } catch {
                single(.failure(ClientError.parseError(error)))
            }
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            let documentReference: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.cultivations).addDocument(data: data) { error in
                if let error = error {
                    dump(error)
                    single(.failure(ClientError.apiError(.createError)))
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                single(.success(documentReference))
            }
            return Disposables.create()
        }
    }

    func putCultivationImage(request: KikurageCultivationRequest, completion: @escaping (Result<Void, ClientError>) -> Void) {
        firestoreClient.putDocumentRequest(request) { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func putCultivationImage(kikurageUserID: String, documentID: String, imageStorageFullPaths: [String]) -> Single<[String]> {
        Single<[String]>.create { single in
            let db = Firestore.firestore()
            let documentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.cultivations).document(documentID)
            documentReference.updateData([
                "imageStoragePaths": imageStorageFullPaths
            ]) { error in
                if let error = error {
                    dump(error)
                    single(.failure(ClientError.apiError(.updateError)))
                } else {
                    single(.success(imageStorageFullPaths))
                }
            }
            return Disposables.create()
        }
    }

    func getCultivations(request: KikurageCultivationRequest, completion: @escaping (Result<[KikurageCultivationTuple], ClientError>) -> Void) {
        firestoreClient.getDocumentsRequest(request) { result in
            switch result {
            case .success(let cultivations):
                completion(.success(cultivations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCultivations(request: KikurageCultivationRequest) -> Single<[KikurageCultivationTuple]> {
        rxFirestoreClient.getDocumentsRequest(request)
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

    func postCultivationImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]> {
        Single<[String]>.create { single in
            var imageStorageFullPaths: [String] = []
            let dispatchSemaphore = DispatchSemaphore(value: 0)
            let dispathcQueue = DispatchQueue(label: "com.shusuke.KikurageApp.upload_cultivation_images_queue")
            var resultError: Error?
            dispathcQueue.async {
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
                if let resultError = resultError {
                    dump(resultError)
                    single(.failure(ClientError.apiError(.createError)))
                } else {
                    single(.success(imageStorageFullPaths))
                }
            }
            return Disposables.create()
        }
    }
}
