//
//  PostCultivationViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostCultivationViewModelDelegate: AnyObject {
    /// 栽培記録の投稿に成功した
    func didSuccessPostCultivation()
    /// 栽培記録の投稿に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedPostCultivation(errorMessage: String)
    /// 栽培記録画像の投稿に成功した
    func didSuccessPostCultivationImages()
    /// 栽培記録画像の投稿に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedPostCultivationImages(errorMessage: String)
}
class PostCultivationViewModel {
    private let cultivationRepository: CultivationRepositoryProtocol

    weak var delegate: PostCultivationViewModelDelegate?
    /// 栽培記録
    var cultivation: KikurageCultivation
    /// 栽培記録のFirestore Document ID
    var postedCultivationDocumentId: String?

    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
        self.cultivation = KikurageCultivation()
    }
}
// MARK: - Firebase Firestore
extension PostCultivationViewModel {
    func postCultivation(kikurageUserId: String) {
        cultivationRepository.postCultivation(kikurageUserId: kikurageUserId, kikurageCultivation: cultivation) { [weak self] response in
            switch response {
            case .success(let documentReference):
                print(documentReference)
                self?.postedCultivationDocumentId = documentReference.documentID
                self?.delegate?.didSuccessPostCultivation()
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedPostCultivation(errorMessage: "DEBUG: 栽培記録データの投稿に失敗しました")
            }
        }
    }
    private func putCultivationImages(kikurageUserId: String, firestoreDocumentId: String, imageStorageFullPaths: [String]) {
        cultivationRepository.putCultivationImage(kikurageUserId: kikurageUserId, documentId: firestoreDocumentId, imageStorageFullPaths: imageStorageFullPaths) { [weak self] response in
            switch response {
            case .success(let imageStorageFullPaths):
                self?.cultivation.imageStoragePaths = imageStorageFullPaths
                self?.delegate?.didSuccessPostCultivationImages()
            case .failure(let error):
                print(error)
                self?.delegate?.didFailedPostCultivation(errorMessage: "DEBUG: 栽培記録画像のStorageパスの保存に失敗しました")
            }
        }
    }
}
// MARK: - Firebase Storage
extension PostCultivationViewModel {
    func postCultivationImages(kikurageUserId: String, imageData: [Data?]) {
        guard let postedCultivationDocumentId = postedCultivationDocumentId else {
            delegate?.didFailedPostCultivationImages(errorMessage: "DEBUG: 栽培記録のドキュメントIDが見つかりませんでした")
            return
        }
        let imageStoragePath = "\(Constants.FirestoreCollectionName.users)/\(kikurageUserId)/\(Constants.FirestoreCollectionName.cultivations)/\(postedCultivationDocumentId)/images/"
        cultivationRepository.postCultivationImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case .success(let imageStorageFullPaths):
                self?.putCultivationImages(kikurageUserId: kikurageUserId, firestoreDocumentId: postedCultivationDocumentId, imageStorageFullPaths: imageStorageFullPaths)
            case .failure(let error):
                print("DEBUG: \(error)")
                self?.delegate?.didFailedPostCultivationImages(errorMessage: "DEBUG: 栽培記録画像の保存に失敗しました")
            }
        }
    }
}
