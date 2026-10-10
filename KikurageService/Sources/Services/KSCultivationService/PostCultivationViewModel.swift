//
//  PostCultivationViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import KDLoginManager
import KDRepository
import KSSDateHelper

@_exported import KDEntity

public protocol PostCultivationViewModelDelegate: AnyObject {
    func postCultivationViewModelDidSuccessPostCultivation(_ postCultivationViewModel: PostCultivationViewModel)
    func postCultivationViewModelDidFailedPostCultivation(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String)
    func postCultivationViewModelDidSuccessPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel)
    func postCultivationViewModelDidFailedPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String)
}

public class PostCultivationViewModel {
    private let cultivationRepository: CultivationRepositoryProtocol
    private let loginManager: LoginManager

    public weak var delegate: PostCultivationViewModelDelegate?

    public let state: PostCultivationState
    public var postedCultivationDocumentID: String?

    public init(
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
    public func postValidation() -> Bool {
        if state.memo.isEmpty {
            state.memo = R.LocalizableString.postCultivationValidMemo
        }
        return true
    }
}

// MARK: - Firebase Firestore

extension PostCultivationViewModel {
    public func postCultivation() {
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
    public func postCultivationImages() {
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
