//
//  PostRecipeViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/30.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostRecipeViewModelDelegate: class {
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
    /// 料理記録リポジトリ
    private let recipeRepository: RecipeRepositoryProtocol
    /// デリゲート
    internal weak var delegate: PostRecipeViewModelDelegate?
    /// 料理記録
    var recipe: KikurageRecipe
    /// 料理記録のFirestore Document ID
    var postedRecipeDocumentId: String?
    
    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
        self.recipe = KikurageRecipe()
    }
}
// MARK: - Firebase Firestore Method
extension PostRecipeViewModel {
    func postRecipe(kikurageUserId: String) {
        self.recipeRepository
            .postRecipe(kikurageUserId: kikurageUserId, kikurageRecipe: self.recipe, completion: { response in
                switch response {
                case .success(let documentReference):
                    print("documentReference = \(documentReference)")
                    self.postedRecipeDocumentId = documentReference.documentID
                    self.delegate?.didSuccessPostRecipe()
                case .failure(let error):
                    print("DEBUG: \(error)")
                    self.delegate?.didFailedPostRecipe(errorMessage: "DEBUG: 料理記録データの投稿に失敗しました")
                }
            })
    }
    private func postRecipeImages(kikurageUserId: String, firestoreDocumentId: String, imageStorageFullPaths: [String]) {
        self.recipeRepository
            .putRecipeImage(kikurageUserId: kikurageUserId, documentId: firestoreDocumentId, imageStorageFullPaths: imageStorageFullPaths,
                            completion: { response in
                                switch response {
                                case .success(let imageStorageFullPaths):
                                    self.recipe.imageStoragePaths = imageStorageFullPaths
                                    self.delegate?.didSuccessPostRecipeImages()
                                case .failure(let error):
                                    print("DEBUG: \(error)")
                                    self.delegate?.didFailedPostRecipeImages(errorMessage: "DEBUG: 料理記録画像のStorageパスの保存に失敗しました")
                                }
                            })
    }
}
// MARK: - Firebase Storage Method
extension PostRecipeViewModel {
    func postRecipeImages(kikurageUserId: String, imageData: [Data?]) {
        guard let postedRecipeDocumentId = self.postedRecipeDocumentId else {
            self.delegate?.didFailedPostRecipeImages(errorMessage: "DEBUG: 料理記録のドキュメントIDが見つかりませんでした")
            return
        }
        let imageStoragePath = "\(Constants.FirestoreCollectionName.users)/\(kikurageUserId)/\(Constants.FirestoreCollectionName.recipes)/\(postedRecipeDocumentId)/images/"
        self.recipeRepository.postRecipeImages(imageData: imageData, imageStoragePath: imageStoragePath, completion: { response in
            switch response {
            case .success(let imageStoraageFullPaths):
                self.postRecipeImages(kikurageUserId: kikurageUserId, firestoreDocumentId: postedRecipeDocumentId, imageStorageFullPaths: imageStoraageFullPaths)
            case .failure(let error):
                print("DEBUG: \(error)")
                self.delegate?.didFailedPostRecipeImages(errorMessage: "DEBUG: 料理記録画像の保存に失敗しました")
            }
        })
    }
}
