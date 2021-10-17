//
//  RecipeRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol RecipeRepositoryProtocol {
    /// 料理記録を投稿する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - kikurageRecipe: Firestoreへ保存する料理記録データ
    ///   - completion: 投稿成功、失敗のハンドル
    func postRecipe(kikurageUserId: String, kikurageRecipe: KikurageRecipe, completion: @escaping (Result<DocumentReference, Error>) -> Void)
    /// 料理画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    ///   - completion: 投稿成功、失敗のハンドル
    func postRecipeImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], Error>) -> Void)
    /// 栽培画像のStoragePathを更新する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - documentId: 料理記録のドキュメントID
    ///   - imageStorageFullPaths: Storageに保存した画像のフルパス
    ///   - completion: 投稿成功、失敗のハンドル
    func putRecipeImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String], completion: @escaping (Result<[String], Error>) -> Void)
    /// 栽培記録を取得する
    /// - Parameters:
    ///   - kikurageUserId: ユーザーID
    ///   - completion: 投稿成功、失敗のハンドル
    func getRecipes(kikurageUserId: String, completion: @escaping (Result<[(recipe: KikurageRecipe, documentId: String)], Error>) -> Void)
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
    func postRecipe(kikurageUserId: String, kikurageRecipe: KikurageRecipe, completion: @escaping (Result<DocumentReference, Error>) -> Void) {
        let db = Firestore.firestore()
        var data: [String: Any]!
        do {
            data = try Firestore.Encoder().encode(kikurageRecipe)
        } catch {
            fatalError(error.localizedDescription)
        }
        let dispathGroup = DispatchGroup()
        dispathGroup.enter()
        let documentReference: DocumentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            }
            dispathGroup.leave()
        }
        // Firestoreにデータを登録した後、Storageに画像を投稿するためのPath用にドキュメントIDをコールバックする
        dispathGroup.notify(queue: .main) {
            completion(.success(documentReference))
        }
    }
    func putRecipeImage(kikurageUserId: String, documentId: String, imageStorageFullPaths: [String], completion: @escaping (Result<[String], Error>) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes).document(documentId)
        documentReference.updateData([
            "imageStoragePaths": imageStorageFullPaths
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(imageStorageFullPaths))
            }
        }
    }
    func getRecipes(kikurageUserId: String, completion: @escaping (Result<[(recipe: KikurageRecipe, documentId: String)], Error>) -> Void) {
        let db = Firestore.firestore()
        let collectionReference = db.collection(Constants.FirestoreCollectionName.users).document(kikurageUserId).collection(Constants.FirestoreCollectionName.recipes)
        collectionReference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(NetworkError.unknown))
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
                completion(.failure(error))
            }
        }
    }
}
// MARK: - Firebase Storage
extension RecipeRepository {
    func postRecipeImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], Error>) -> Void) {
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
                let fileName: String = DateHelper.shared.formatToStringForImageData(date: Date()) + "_\(i).jpeg"
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
                    completion(.failure(resultError))
                } else {
                    completion(.success(imageStorageFullPaths))
                }
            }
        }
    }
}
