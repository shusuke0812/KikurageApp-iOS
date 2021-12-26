//
//  PostRecipeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/30.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

protocol PostRecipeViewModelDelegate: AnyObject {
    /// 料理記録の投稿に成功した
    func didSuccessPostRecipe()
    /// 料理記録の投稿に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedPostRecipe(errorMessage: String)
    /// 料理記録画像の投稿に成功した
    func didSuccessPostRecipeImages()
    /// 料理記録画像の投稿に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedPostRecipeImages(errorMessage: String)
}

class PostRecipeViewModel {
    private let recipeRepository: RecipeRepositoryProtocol

    weak var delegate: PostRecipeViewModelDelegate?
    /// 料理記録
    var recipe: KikurageRecipe
    /// 料理記録のFirestore Document ID
    var postedRecipeDocumentId: String?

    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
        self.recipe = KikurageRecipe()
    }
}

// MARK: - Firebase Firestore

extension PostRecipeViewModel {
    func postRecipe(kikurageUserId: String) {
        recipeRepository.postRecipe(kikurageUserId: kikurageUserId, kikurageRecipe: recipe) { [weak self] response in
            switch response {
            case .success(let documentReference):
                self?.postedRecipeDocumentId = documentReference.documentID
                self?.delegate?.didSuccessPostRecipe()
            case .failure(let error):
                self?.delegate?.didFailedPostRecipe(errorMessage: error.description())
            }
        }
    }
    private func postRecipeImages(kikurageUserId: String, firestoreDocumentId: String, imageStorageFullPaths: [String]) {
        recipeRepository.putRecipeImage(kikurageUserId: kikurageUserId, documentId: firestoreDocumentId, imageStorageFullPaths: imageStorageFullPaths) { [weak self] response in
            switch response {
            case .success(let imageStorageFullPaths):
                self?.recipe.imageStoragePaths = imageStorageFullPaths
                self?.delegate?.didSuccessPostRecipeImages()
            case .failure(let error):
                self?.delegate?.didFailedPostRecipeImages(errorMessage: error.description())
            }
        }
    }
}

// MARK: - Firebase Storage

extension PostRecipeViewModel {
    func postRecipeImages(kikurageUserId: String, imageData: [Data?]) {
        guard let postedRecipeDocumentId = postedRecipeDocumentId else {
            delegate?.didFailedPostRecipeImages(errorMessage: FirebaseAPIError.documentIdError.description())
            return
        }
        let imageStoragePath = "\(Constants.FirestoreCollectionName.users)/\(kikurageUserId)/\(Constants.FirestoreCollectionName.recipes)/\(postedRecipeDocumentId)/images/"
        recipeRepository.postRecipeImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case .success(let imageStoraageFullPaths):
                self?.postRecipeImages(kikurageUserId: kikurageUserId, firestoreDocumentId: postedRecipeDocumentId, imageStorageFullPaths: imageStoraageFullPaths)
            case .failure(let error):
                self?.delegate?.didFailedPostRecipeImages(errorMessage: error.description())
            }
        }
    }
}
