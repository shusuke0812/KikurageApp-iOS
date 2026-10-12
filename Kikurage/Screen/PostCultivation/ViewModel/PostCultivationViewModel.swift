//
//  PostCultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDLoginManager
import KDRepository

protocol PostCultivationViewModelDelegate: AnyObject {
    func postCultivationViewModelDidSuccessPostCultivation(_ postCultivationViewModel: PostCultivationViewModel)
    func postCultivationViewModelDidFailedPostCultivation(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String)
    func postCultivationViewModelDidSuccessPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel)
    func postCultivationViewModelDidFailedPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String)
}

class PostCultivationViewModel {
    private let cultivationRepository: CultivationRepositoryProtocol
    private let loginManager: LoginManager

    weak var delegate: PostCultivationViewModelDelegate?

    let state: PostCultivationState
    var postedCultivationDocumentID: String?

    init(
        maxImageCount: Int,
        cultivationRepository: CultivationRepositoryProtocol = CultivationRepository()
    ) {
        self.cultivationRepository = cultivationRepository
        state = PostCultivationState(maxImageCount: maxImageCount)
        loginManager = LoginManager()
    }
}

// MARK: - Validation

extension PostCultivationViewModel {
    func postValidation() -> Bool {
        if state.memo.isEmpty {
            state.memo = R.string.localizable.screen_post_cultivation_valid_memo()
        }
        return true
    }
}

// MARK: - Firebase Firestore

extension PostCultivationViewModel {
    func postCultivation() {
        guard let userID = loginManager.userID else {
            delegate?.postCultivationViewModelDidFailedPostCultivation(self, with: "error") // TODO: Error型を定義してVCに通知する
            return
        }
        var cultivation = KikurageCultivation()
        cultivation.memo = state.memo
        cultivation.viewDate = DateHelper.formatToString(date: state.date)

        var request = KikurageCultivationRequest(kikurageUserID: userID)
        request.body = request.buildBody(from: cultivation)
        cultivationRepository.postCultivation(request: request) { [weak self] response in
            switch response {
            case .success(let documentID):
                self?.postedCultivationDocumentID = documentID
                self?.delegate?.postCultivationViewModelDidSuccessPostCultivation(self!)
            case .failure(let error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivation(self!, with: error.description())
            }
        }
    }

    private func putCultivationImagePaths(kikurageUserID: String, firestoreDocumentID: String, imageStorageFullPaths: [String]) {
        var request = KikurageCultivationRequest(kikurageUserID: kikurageUserID, documentID: firestoreDocumentID)
        request.body = ["imageStoragePaths": imageStorageFullPaths]
        cultivationRepository.putCultivationImagePaths(request: request) { [weak self] response in
            switch response {
            case .success():
                self?.delegate?.postCultivationViewModelDidSuccessPostCultivationImages(self!)
            case .failure(let error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivation(self!, with: error.description())
            }
        }
    }
}

// MARK: - Firebase Storage

extension PostCultivationViewModel {
    func postCultivationImages() {
        guard let userID = loginManager.userID, let postedCultivationDocumentID = postedCultivationDocumentID else {
            delegate?.postCultivationViewModelDidFailedPostCultivationImages(self, with: "error") // TODO: FirebaseAPIError.documentIDError.description()
            return
        }
        let imageData: [Data?] = state.selectedImages
            .compactMap { $0 }
            .map { $0.jpegData(compressionQuality: 0.3) }
        let imageStoragePath = "\(FirestoreCollectionName.users)/\(userID)/\(FirestoreCollectionName.cultivations)/\(postedCultivationDocumentID)/images/"
        cultivationRepository.postCultivationImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case .success(let imageStorageFullPaths):
                self?.putCultivationImagePaths(kikurageUserID: userID, firestoreDocumentID: postedCultivationDocumentID, imageStorageFullPaths: imageStorageFullPaths)
            case .failure(let error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivationImages(self!, with: error.description())
            }
        }
    }
}
