//
//  CultivationRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDFirebase
import KDEntity
import RxSwift
import Foundation

public protocol CultivationRepositoryProtocol {
    /// - Parameters:
    ///   - completion: [Success] Document  ID to save images in Firebase Storage
    func postCultivation(request: KikurageCultivationRequest, completion: @escaping (Result<String, FirebaseClientError>) -> Void)
    func postCultivation(request: KikurageCultivationRequest) -> Single<String>
    /// 栽培画像を保存する（直列処理）
    /// - Parameters:
    ///   - imageData: 保存する画像データ
    ///   - imageStoragePath: 画像を保存するStorageパス
    ///   - completion: 投稿成功、失敗のハンドル
    func postCultivationImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], FirebaseClientError>) -> Void)
    func postCultivationImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]>
    /// 栽培画像のStoragePathを更新する
    func putCultivationImage(request: KikurageCultivationRequest, completion: @escaping (Result<Void, FirebaseClientError>) -> Void)
    func putCultivationImage(request: KikurageCultivationRequest) -> Single<Void>
    /// 栽培記録を取得する
    func getCultivations(request: KikurageCultivationRequest, completion: @escaping (Result<[KikurageCultivationTuple], FirebaseClientError>) -> Void)
    func getCultivations(request: KikurageCultivationRequest) -> Single<[KikurageCultivationTuple]>
}

public class CultivationRepository: CultivationRepositoryProtocol {
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

extension CultivationRepository {
    public func postCultivation(request: KikurageCultivationRequest, completion: @escaping (Result<String, FirebaseClientError>) -> Void) {
        firestoreClient.postDocumentWithGetReferenceRequest(request) { result in
            switch result {
            case .success(let documentReference):
                completion(.success(documentReference.documentID))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func postCultivation(request: KikurageCultivationRequest) -> Single<String> {
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

    public func putCultivationImage(request: KikurageCultivationRequest, completion: @escaping (Result<Void, FirebaseClientError>) -> Void) {
        firestoreClient.putDocumentRequest(request) { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func putCultivationImage(request: KikurageCultivationRequest) -> Single<Void> {
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
    
    public func getCultivations(request: KikurageCultivationRequest, completion: @escaping (Result<[KikurageCultivationTuple], FirebaseClientError>) -> Void) {
        firestoreClient.getDocumentsRequest(request) { result in
            switch result {
            case .success(let cultivations):
                completion(.success(cultivations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func getCultivations(request: KikurageCultivationRequest) -> Single<[KikurageCultivationTuple]> {
        rxFirestoreClient.getDocumentsRequest(request)
    }
}

// MARK: - Firebase Storage

extension CultivationRepository {
    public func postCultivationImages(imageData: [Data?], imageStoragePath: String, completion: @escaping (Result<[String], FirebaseClientError>) -> Void) {
        firebaseStorageClient.postImages(imageData: imageData, imageStoragePath: imageStoragePath) { result in
            switch result {
            case .success(let imageStoragePaths):
                completion(.success(imageStoragePaths))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func postCultivationImages(imageData: [Data?], imageStoragePath: String) -> Single<[String]> {
        return firebaseStorageClient.postImages(imageData: imageData, imageStoragePath: imageStoragePath)
    }
}
