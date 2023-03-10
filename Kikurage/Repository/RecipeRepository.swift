//
//  RecipeRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import RxSwift
import UIKit

protocol RecipeRepositoryProtocol {
    /// 料理記録を投稿する
    func postRecipe(request: KikurageRecipeRequest, completion: @escaping (Result<DocumentReference, ClientError>) -> Void)
    func postRecipe(kikurageUserID: String, kikurageRecipe: KikurageRecipe) -> Single<DocumentReference>
    /// 料理画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    ///   - completion: 投稿成功、失敗のハンドル
    func postRecipeImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], ClientError>) -> Void)
    func postRecipeImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]>
    /// 栽培画像のStoragePathを更新する
    func putRecipeImage(request: KikurageRecipeRequest, completion: @escaping (Result<Void, ClientError>) -> Void)
    func putRecipeImage(kikurageUserID: String, documentID: String, imageStorageFullPaths: [String]) -> Single<[String]>
    /// 栽培記録を取得する
    func getRecipes(request: KikurageRecipeRequest, completion: @escaping (Result<[KikurageRecipeTuple], ClientError>) -> Void)
    func getRecipes(request: KikurageRecipeRequest) -> Single<[KikurageRecipeTuple]>
}

class RecipeRepository: RecipeRepositoryProtocol {
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

extension RecipeRepository {
    func postRecipe(request: KikurageRecipeRequest, completion: @escaping (Result<DocumentReference, ClientError>) -> Void) {
        firestoreClient.postDocumentWithGetReferenceReques(request) { result in
            switch result {
            case let .success(documentReference):
                completion(.success(documentReference))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func postRecipe(kikurageUserID: String, kikurageRecipe: KikurageRecipe) -> Single<DocumentReference> {
        Single<DocumentReference>.create { single in
            let db = Firestore.firestore()
            var data: [String: Any]!
            do {
                data = try Firestore.Encoder().encode(kikurageRecipe)
            } catch {
                single(.failure(ClientError.parseError(error)))
            }
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            let documentReference: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.recipes).addDocument(data: data) { error in
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

    func putRecipeImage(request: KikurageRecipeRequest, completion: @escaping (Result<Void, ClientError>) -> Void) {
        firestoreClient.putDocumentRequest(request) { result in
            switch result {
            case .success():
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func putRecipeImage(kikurageUserID: String, documentID: String, imageStorageFullPaths: [String]) -> Single<[String]> {
        Single<[String]>.create { single in
            let db = Firestore.firestore()
            let documentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserID).collection(Constants.FirestoreCollectionName.recipes).document(documentID)
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

    func getRecipes(request: KikurageRecipeRequest, completion: @escaping (Result<[KikurageRecipeTuple], ClientError>) -> Void) {
        firestoreClient.getDocumentsRequest(request) { result in
            switch result {
            case let .success(recipes):
                completion(.success(recipes))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getRecipes(request: KikurageRecipeRequest) -> Single<[KikurageRecipeTuple]> {
        rxFirestoreClient.getDocumentsRequest(request)
    }
}

// MARK: - Firebase Storage

extension RecipeRepository {
    func postRecipeImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], ClientError>) -> Void) {
        // 画像保存後のフルパス格納用
        var imageStorageFullPaths: [String] = []
        // 直列処理（画像を１つずつ保存する）
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue(label: "com.shusuke.KikurageApp.upload_recipe_images_queue")
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

    func postRecipeImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]> {
        Single<[String]>.create { single in
            var imageStorageFullPaths: [String] = []
            let dispatchSemaphore = DispatchSemaphore(value: 0)
            let dispatchQueue = DispatchQueue(label: "com.shusuke.KikurageApp.upload_recipe_images_queue")
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
