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
    var postedRecipeDocumentID: String?

    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
        recipe = KikurageRecipe()
    }
}

// MARK: - Firebase Firestore

extension PostRecipeViewModel {
    func postRecipe(kikurageUserID: String) {
        var request = KikurageRecipeRequest(kikurageUserID: kikurageUserID)
        request.body = request.buildBody(from: recipe)
        recipeRepository.postRecipe(request: request) { [weak self] response in
            switch response {
            case let .success(documentReference):
                self?.postedRecipeDocumentID = documentReference.documentID
                self?.delegate?.postRecipeViewModelDidSuccessPostRecipe(self!)
            case let .failure(error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipe(self!, with: error.description())
            }
        }
    }

    private func putRecipeImages(kikurageUserID: String, firestoreDocumentID: String, imageStorageFullPaths: [String]) {
        var request = KikurageRecipeRequest(kikurageUserID: kikurageUserID, documentID: firestoreDocumentID)
        request.body = ["imageStoragePaths": imageStorageFullPaths]
        recipeRepository.putRecipeImage(request: request) { [weak self] response in
            switch response {
            case .success():
                self?.delegate?.postRecipeViewModelDidSuccessPostRecipeImages(self!)
            case let .failure(error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipeImages(self!, with: error.description())
            }
        }
    }
}

// MARK: - Firebase Storage

extension PostRecipeViewModel {
    func postRecipeImages(kikurageUserID: String, imageData: [Data?]) {
        guard let postedRecipeDocumentID = postedRecipeDocumentID else {
            delegate?.postRecipeViewModelDidFailedPostRecipeImages(self, with: FirebaseAPIError.documentIDError.description())
            return
        }
        let imageStoragePath = "\(Constants.FirestoreCollectionName.users)/\(kikurageUserID)/\(Constants.FirestoreCollectionName.recipes)/\(postedRecipeDocumentID)/images/"
        recipeRepository.postRecipeImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case let .success(imageStorageFullPaths):
                self?.putRecipeImages(kikurageUserID: kikurageUserID, firestoreDocumentID: postedRecipeDocumentID, imageStorageFullPaths: imageStorageFullPaths)
            case let .failure(error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipeImages(self!, with: error.description())
            }
        }
    }
}
