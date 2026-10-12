//
//  PostRecipeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/30.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDLoginManager
import KDRepository

protocol PostRecipeViewModelDelegate: AnyObject {
    func postRecipeViewModelDidSuccessPostRecipe(_ postRecipeViewModel: PostRecipeViewModel)
    func postRecipeViewModelDidFailedPostRecipe(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String)
    func postRecipeViewModelDidSuccessPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel)
    func postRecipeViewModelDidFailedPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String)
}

class PostRecipeViewModel {
    private let recipeRepository: RecipeRepositoryProtocol
    private let loginManager: LoginManager

    weak var delegate: PostRecipeViewModelDelegate?

    let state: PostRecipeState
    var postedRecipeDocumentID: String?

    init(
        maxImageCount: Int,
        recipeRepository: RecipeRepositoryProtocol = RecipeRepository()
    ) {
        self.recipeRepository = recipeRepository
        state = PostRecipeState(maxImageCount: maxImageCount)
        loginManager = LoginManager()
    }
}

// MARK: - Firebase Firestore

extension PostRecipeViewModel {
    func postRecipe() {
        guard let userID = loginManager.userID else {
            delegate?.postRecipeViewModelDidFailedPostRecipe(self, with: "error")
            return
        }
        var recipe = KikurageRecipe()
        recipe.name = state.name
        recipe.memo = state.memo
        recipe.cookDate = DateHelper.formatToString(date: state.date)

        var request = KikurageRecipeRequest(kikurageUserID: userID)
        request.body = request.buildBody(from: recipe)
        recipeRepository.postRecipe(request: request) { [weak self] response in
            switch response {
            case .success(let documentID):
                self?.postedRecipeDocumentID = documentID
                self?.delegate?.postRecipeViewModelDidSuccessPostRecipe(self!)
            case .failure(let error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipe(self!, with: error.description())
            }
        }
    }

    private func putRecipeImagePaths(kikurageUserID: String, firestoreDocumentID: String, imageStorageFullPaths: [String]) {
        var request = KikurageRecipeRequest(kikurageUserID: kikurageUserID, documentID: firestoreDocumentID)
        request.body = ["imageStoragePaths": imageStorageFullPaths]
        recipeRepository.putRecipeImagePaths(request: request) { [weak self] response in
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
    func postRecipeImages() {
        guard let userID = loginManager.userID, let postedRecipeDocumentID = postedRecipeDocumentID else {
            delegate?.postRecipeViewModelDidFailedPostRecipeImages(self, with: "error") // TODO: FirebaseAPIError.documentIDError.description()
            return
        }
        let imageData: [Data?] = state.selectedImages
            .compactMap { $0 }
            .map { $0.jpegData(compressionQuality: 0.3) }
        let imageStoragePath = "\(FirestoreCollectionName.users)/\(userID)/\(FirestoreCollectionName.recipes)/\(postedRecipeDocumentID)/images/"
        recipeRepository.postRecipeImages(imageData: imageData, imageStoragePath: imageStoragePath) { [weak self] response in
            switch response {
            case .success(let imageStorageFullPaths):
                self?.putRecipeImagePaths(kikurageUserID: userID, firestoreDocumentID: postedRecipeDocumentID, imageStorageFullPaths: imageStorageFullPaths)
            case .failure(let error):
                self?.delegate?.postRecipeViewModelDidFailedPostRecipeImages(self!, with: error.description())
            }
        }
    }
}
