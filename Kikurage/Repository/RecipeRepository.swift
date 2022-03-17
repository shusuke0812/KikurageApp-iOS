//
//  RecipeRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase
import RxSwift

protocol RecipeRepositoryProtocol {
    /// 料理記録を投稿する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - kikurageRecipe: Firestoreへ保存する料理記録データ
    ///   - completion: 投稿成功、失敗のハンドル
    func postRecipe(kikurageUserId: String, kikurageRecipe: KikurageRecipe, completion: @escaping (Result<DocumentReference, ClientError>) -> Void)
    func postRecipe(kikurageUserId: String, kikurageRecipe: KikurageRecipe) -> Single<DocumentReference>
    /// 料理画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    ///   - completion: 投稿成功、失敗のハンドル
    func postRecipeImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], ClientError>) -> Void)
    func postRecipeImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]>
    /// 栽培画像のStoragePathを更新する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - documentId: 料理記録のドキュメントID
    ///   - imageStorageFullPaths: Storageに保存した画像のフルパス
    ///   - completion: 投稿成功、失敗のハンドル
    func putRecipeImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String], completion: @escaping (Result<[String], ClientError>) -> Void)
    func putRecipeImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String]) -> Single<[String]>
    /// 栽培記録を取得する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - completion: 投稿成功、失敗のハンドル
    func getRecipes(kikurageUserId: String, completion: @escaping (Result<[(recipe: KikurageRecipe, documentId: String)], ClientError>) -> Void)
    func getRecipes(kikurageUserId: String) -> Single<[(recipe: KikurageRecipe, documentId: String)]>
}

class RecipeRepository: RecipeRepositoryProtocol {
    /// Storageへ保存するデータのメタデータ
    private let metaData: StorageMetadata

    init() {
        self.metaData = StorageMetadata()
        self.metaData.contentType = "image/jpeg"
    }
}

// MARK: - Firebase Firestore

extension RecipeRepository {
    func postRecipe(kikurageUserId: String, kikurageRecipe: KikurageRecipe, completion: @escaping (Result<DocumentReference, ClientError>) -> Void) {
        let db = Firestore.firestore()
        var data: [String: Any]!
        do {
            data = try Firestore.Encoder().encode(kikurageRecipe)
        } catch {
            completion(.failure(ClientError.parseError(error)))
        }
        let dispathGroup = DispatchGroup()
        dispathGroup.enter()
        let documentReference: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes).addDocument(data: data) { error in
            if let error = error {
                dump(error)
                completion(.failure(ClientError.apiError(.createError)))
            }
            dispathGroup.leave()
        }
        // Firestoreにデータを登録した後、Storageに画像を投稿するためのPath用にドキュメントIDをコールバックする
        dispathGroup.notify(queue: .main) {
            completion(.success(documentReference))
        }
    }
    func postRecipe(kikurageUserId: String, kikurageRecipe: KikurageRecipe) -> Single<DocumentReference> {
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
            let documentReference: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes).addDocument(data: data) { error in
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
    func putRecipeImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String], completion: @escaping (Result<[String], ClientError>) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes).document(documentId)
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
    func putRecipeImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String]) -> Single<[String]> {
        Single<[String]>.create { single in
            let db = Firestore.firestore()
            let documentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes).document(documentId)
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
    func getRecipes(kikurageUserId: String, completion: @escaping (Result<[(recipe: KikurageRecipe, documentId: String)], ClientError>) -> Void) {
        let db = Firestore.firestore()
        let collectionReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes)
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
            var recipes: [(recipe: KikurageRecipe, documentId: String)] = []
            do {
                for document in snapshot.documents {
                    let recipe = try Firestore.Decoder().decode(KikurageRecipe.self, from: document.data())
                    recipes.append((recipe: recipe, documentId: document.documentID))
                }
                completion(.success(recipes))
            } catch {
                completion(.failure(ClientError.responseParseError(error)))
            }
        }
    }
    func getRecipes(kikurageUserId: String) -> Single<[(recipe: KikurageRecipe, documentId: String)]> {
        Single<[(recipe: KikurageRecipe, documentId: String)]>.create { single in
            let db = Firestore.firestore()
            let collectionReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes)
            collectionReference.getDocuments { snapshot, error in
                if let error = error {
                    dump(error)
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                guard let snapshot = snapshot else {
                    single(.failure(ClientError.apiError(.readError)))
                    return
                }
                var recipes: [(recipe: KikurageRecipe, documentId: String)] = []
                do {
                    for document in snapshot.documents {
                        let recipe = try Firestore.Decoder().decode(KikurageRecipe.self, from: document.data())
                        recipes.append((recipe: recipe, documentId: document.documentID))
                    }
                    single(.success(recipes))
                } catch {
                    single(.failure(ClientError.responseParseError(error)))
                }
            }
            return Disposables.create()
        }
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
