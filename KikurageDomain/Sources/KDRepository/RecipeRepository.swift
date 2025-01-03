//
//  RecipeRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDFirebase
import KDEntity
import Foundation
import RxSwift

public protocol RecipeRepositoryProtocol {
    /// 料理記録を投稿する
    func postRecipe(request: KikurageRecipeRequest, completion: @escaping (Result<String, FirebaseClientError>) -> Void)
    func postRecipe(request: KikurageRecipeRequest) -> Single<String>
    /// 料理画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    ///   - completion: 投稿成功、失敗のハンドル
    func postRecipeImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], FirebaseClientError>) -> Void)
    func postRecipeImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]>
    /// 栽培画像のStoragePathを更新する
    func putRecipeImage(request: KikurageRecipeRequest, completion: @escaping (Result<Void, FirebaseClientError>) -> Void)
    func putRecipeImage(request: KikurageRecipeRequest) -> Single<Void>
    /// 栽培記録を取得する
    func getRecipes(request: KikurageRecipeRequest, completion: @escaping (Result<[KikurageRecipeTuple], FirebaseClientError>) -> Void)
    func getRecipes(request: KikurageRecipeRequest) -> Single<[KikurageRecipeTuple]>
}

public class RecipeRepository: RecipeRepositoryProtocol {
    private let firestoreClient: FirestoreClientProtocol
    private let firebaseStorageClient: FirebaseStorageClientProtocol
    private let rxFirestoreClient: RxFirestoreClientProtocol

    public init(
        firestoreClient: FirestoreClientProtocol = FirestoreClient(),
        rxFirestoreClient: RxFirestoreClientProtocol = RxFirestoreClient(),
        firebaseStorageClient: FirebaseStorageClientProtocol = FirebaseStorageClient()
    ) {
        self.firestoreClient = firestoreClient
        self.rxFirestoreClient = rxFirestoreClient
        self.firebaseStorageClient = firebaseStorageClient
    }
}

// MARK: - Firebase Firestore

extension RecipeRepository {
    public func postRecipe(request: KikurageRecipeRequest, completion: @escaping (Result<String, FirebaseClientError>) -> Void) {
        firestoreClient.postDocumentWithGetReferenceRequest(request) { result in
            switch result {
            case .success(let documentReference):
                completion(.success(documentReference.documentID))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func postRecipe(request: KikurageRecipeRequest) -> Single<String> {
        Single<String>.create { [weak self] single in
            self?.firestoreClient.postDocumentWithGetReferenceRequest(request) { result in
                switch result {
                case .success(let documentReference):
                    single(.success(documentReference.documentID))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    public func putRecipeImage(request: KikurageRecipeRequest, completion: @escaping (Result<Void, FirebaseClientError>) -> Void) {
        firestoreClient.putDocumentRequest(request) { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func putRecipeImage(request: KikurageRecipeRequest) -> Single<Void> {
        Single<Void>.create { [weak self] single in
            self?.firestoreClient.putDocumentRequest(request) { result in
                switch result {
                case .success:
                    single(.success(()))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    public func getRecipes(request: KikurageRecipeRequest, completion: @escaping (Result<[KikurageRecipeTuple], FirebaseClientError>) -> Void) {
        firestoreClient.getDocumentsRequest(request) { result in
            switch result {
            case .success(let recipes):
                completion(.success(recipes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func getRecipes(request: KikurageRecipeRequest) -> Single<[KikurageRecipeTuple]> {
        rxFirestoreClient.getDocumentsRequest(request)
    }
}

// MARK: - Firebase Storage

extension RecipeRepository {
    public func postRecipeImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], FirebaseClientError>) -> Void) {
        firebaseStorageClient.postImages(imageData: imageData, imageStoragePath: imageStoragePath) { result in
            switch result {
            case .success(let imageStoragePaths):
                completion(.success(imageStoragePaths))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func postRecipeImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]> {
        return firebaseStorageClient.postImages(imageData: imageData, imageStoragePath: imageStoragePath)
    }
}
