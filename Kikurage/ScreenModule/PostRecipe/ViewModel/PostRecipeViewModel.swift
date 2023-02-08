//
//  PostRecipeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/30.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

protocol PostRecipeViewModelDelegate: AnyObject {
    func postRecipeViewModelDidSuccessPostRecipe(_ postRecipeViewModel: PostRecipeViewModel)
    func postRecipeViewModelDidFailedPostRecipe(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String)
    func postRecipeViewModelDidSuccessPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel)
    func postRecipeViewModelDidFailedPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String)
}

class PostRecipeViewModel {
    private let recipeRepository: RecipeRepositoryProtocol

    weak var delegate: PostRecipeViewModelDelegate?

    var recipe: KikurageRecipe
    var postedRecipeDocumentId: String?

    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
        self.recipe = KikurageRecipe()
    }
}

// MARK: - Firebase Firestore

extension PostRecipeViewModel {
    func postRecipe(kikurageUserId: String) {
        var request = KikurageRecipeRequest(kikurageUserId: kikurageUserId)
        request.body = request.buildBody(from: recipe)
        recipeRepository.postRecipe(request: request) { [weak self] response in
            switch response {
            case .success(let documentReference):
                self?.postedRecipeDocumentId = documentReference.documentID
                self?.delegate?.postRecipeViewModelDidSuccessPostRecipe(self!)
            case .failure(let error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipe(self!, with: error.description())
            }
        }
    }
    private func putRecipeImages(kikurageUserId: String, firestoreDocumentId: String, imageStorageFullPaths: [String]) {
        let request = KikurageRecipeRequest(kikurageUserId: kikurageUserId, documentId: firestoreDocumentId, imageStorageFullPaths: imageStorageFullPaths)
        recipeRepository.putRecipeImage(request: request) { [weak self] response in
            switch response {
            case .success():
                self?.delegate?.postRecipeViewModelDidSuccessPostRecipeImages(self!)
            case .failure(let error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipeImages(self!, with: error.description())
            }
        }
    }
}

// MARK: - Firebase Storage

extension PostRecipeViewModel {
    func postRecipeImages(kikurageUserId: String, imageData: [Data?]) {
        guard let postedRecipeDocumentId = postedRecipeDocumentId else {
            delegate?.postRecipeViewModelDidFailedPostRecipeImages(self, with: FirebaseAPIError.documentIdError.description())
            return
        }
        let imageStoragePath = "\(Constants.FirestoreCollectionName.users)/\(kikurageUserId)/\(Constants.FirestoreCollectionName.recipes)/\(postedRecipeDocumentId)/images/"
        recipeRepository.postRecipeImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case .success(let imageStorageFullPaths):
                self?.putRecipeImages(kikurageUserId: kikurageUserId, firestoreDocumentId: postedRecipeDocumentId, imageStorageFullPaths: imageStorageFullPaths)
            case .failure(let error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipeImages(self!, with: error.description())
            }
        }
    }
}
