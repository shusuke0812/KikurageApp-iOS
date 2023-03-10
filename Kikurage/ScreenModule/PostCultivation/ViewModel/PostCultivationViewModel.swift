//
//  PostCultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

protocol PostCultivationViewModelDelegate: AnyObject {
    func postCultivationViewModelDidSuccessPostCultivation(_ postCultivationViewModel: PostCultivationViewModel)
    func postCultivationViewModelDidFailedPostCultivation(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String)
    func postCultivationViewModelDidSuccessPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel)
    func postCultivationViewModelDidFailedPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String)
}

class PostCultivationViewModel {
    private let cultivationRepository: CultivationRepositoryProtocol

    weak var delegate: PostCultivationViewModelDelegate?

    var cultivation: KikurageCultivation
    var postedCultivationDocumentID: String?

    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
        cultivation = KikurageCultivation()
    }
}

// MARK: - Validation

extension PostCultivationViewModel {
    func postValidation() -> Bool {
        if cultivation.viewDate.isEmpty {
            return false
        }
        if cultivation.memo.isEmpty {
            cultivation.memo = R.string.localizable.screen_post_cultivation_valid_memo()
        }
        return true
    }
}

// MARK: - Firebase Firestore

extension PostCultivationViewModel {
    func postCultivation(kikurageUserID: String) {
        var request = KikurageCultivationRequest(kikurageUserID: kikurageUserID)
        request.body = request.buildBody(from: cultivation)
        cultivationRepository.postCultivation(request: request) { [weak self] response in
            switch response {
            case let .success(documentReference):
                self?.postedCultivationDocumentID = documentReference.documentID
                self?.delegate?.postCultivationViewModelDidSuccessPostCultivation(self!)
            case let .failure(error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivation(self!, with: error.description())
            }
        }
    }

    private func putCultivationImages(kikurageUserID: String, firestoreDocumentID: String, imageStorageFullPaths: [String]) {
        var request = KikurageCultivationRequest(kikurageUserID: kikurageUserID, documentID: firestoreDocumentID)
        request.body = ["imageStoragePaths": imageStorageFullPaths]
        cultivationRepository.putCultivationImage(request: request) { [weak self] response in
            switch response {
            case .success():
                self?.cultivation.imageStoragePaths = imageStorageFullPaths
                self?.delegate?.postCultivationViewModelDidSuccessPostCultivationImages(self!)
            case let .failure(error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivation(self!, with: error.description())
            }
        }
    }
}

// MARK: - Firebase Storage

extension PostCultivationViewModel {
    func postCultivationImages(kikurageUserID: String, imageData: [Data?]) {
        guard let postedCultivationDocumentID = postedCultivationDocumentID else {
            delegate?.postCultivationViewModelDidFailedPostCultivationImages(self, with: FirebaseAPIError.documentIDError.description())
            return
        }
        let imageStoragePath = "\(Constants.FirestoreCollectionName.users)/\(kikurageUserID)/\(Constants.FirestoreCollectionName.cultivations)/\(postedCultivationDocumentID)/images/"
        cultivationRepository.postCultivationImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case let .success(imageStorageFullPaths):
                self?.putCultivationImages(kikurageUserID: kikurageUserID, firestoreDocumentID: postedCultivationDocumentID, imageStorageFullPaths: imageStorageFullPaths)
            case let .failure(error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivationImages(self!, with: error.description())
            }
        }
    }
}
