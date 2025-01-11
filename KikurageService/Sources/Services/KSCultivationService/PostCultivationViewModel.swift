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
import KSSDateHelper

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

    public var cultivation: KikurageCultivation
    public var postedCultivationDocumentID: String?

    public init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
        cultivation = KikurageCultivation()
        loginManager = LoginManager()
    }

    public func updateViewDate(date: Date) {
        let dateString = DateHelper.formatToString(date: date)
        cultivation.viewDate = dateString
    }
}

// MARK: - Validation

extension PostCultivationViewModel {
    public func postValidation() -> Bool {
        if cultivation.viewDate.isEmpty {
            return false
        }
        if cultivation.memo.isEmpty {
            cultivation.memo = "memo" // TODO: R.string.localizable.screen_post_cultivation_valid_memo()
        }
        return true
    }
}

// MARK: - Firebase Firestore

extension PostCultivationViewModel {
    public func postCultivation() {
        guard let userID = loginManager.userID else {
            delegate?.postCultivationViewModelDidFailedPostCultivation(self, with: "error")
            return
        }
        var request = KikurageCultivationRequest(kikurageUserID: userID)
        request.body = request.buildBody(from: cultivation)
        cultivationRepository.postCultivation(request: request) { [weak self] response in
            switch response {
            case .success(let documentID):
                self?.postedCultivationDocumentID = documentID
                self?.delegate?.postCultivationViewModelDidSuccessPostCultivation(self!)
            case .failure(let error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivation(self!, with: "error") // TODO: error.description()
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
            case .failure(let error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivation(self!, with: error.description())
            }
        }
    }
}

// MARK: - Firebase Storage

extension PostCultivationViewModel {
    public func postCultivationImages(imageData: [Data?]) {
        guard let userID = loginManager.userID, let postedCultivationDocumentID = postedCultivationDocumentID else {
            delegate?.postCultivationViewModelDidFailedPostCultivationImages(self, with: "error") // TODO: FirebaseAPIError.documentIDError.description()
            return
        }
        let imageStoragePath = "\(FirestoreCollectionName.users)/\(userID)/\(FirestoreCollectionName.cultivations)/\(postedCultivationDocumentID)/images/"
        cultivationRepository.postCultivationImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case .success(let imageStorageFullPaths):
                self?.putCultivationImages(kikurageUserID: userID, firestoreDocumentID: postedCultivationDocumentID, imageStorageFullPaths: imageStorageFullPaths)
            case .failure(let error):
                self?.delegate?.postCultivationViewModelDidFailedPostCultivationImages(self!, with: error.description())
            }
        }
    }
}
