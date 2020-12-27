//
//  RecipeRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol RecipeRepositoryProtocol {
    /// 料理記録を投稿する
    func postRecipe(kikurageUserId: String,
                    kikuraageRecipe: KikurageRecipe,
                    completion: @escaping (Result<DocumentReference, Error>) -> Void)
    /// 料理画像を保存する（直列処理）
    func postRecipeImages(imageData: [Data?], imageStoragePath: String,
                          completion: @escaping (Result<[String], Error>) -> Void)
    /// 栽培画像のStoragePathを更新する
    func putRecipeImage(kikurageUserId: String, documentId: String, imageStoragePaths: [String],
                        completion: @escaping (Result<[String], Error>) -> Void)
    /// 栽培記録を取得する
    func getRecipes(kikurageUserId: String, completion: @escaping (Result<[(recipe: KikurageRecipe, documentId: String)], Error>) -> Void)
}

class RecipeRepository: RecipeRepositoryProtocol {
    // Storageへ保存するデータのメタデータ
    private let metaData: StorageMetadata
    
    init() {
        self.metaData = StorageMetadata()
        self.metaData.contentType = "image/jpeg"
    }
}
// MARK: - Firebase Firestore Method
extension RecipeRepository {
    func postRecipe(kikurageUserId: String,
                    kikuraageRecipe: KikurageRecipe,
                    completion: @escaping (Result<DocumentReference, Error>) -> Void) {
        <#code#>
    }
    func putRecipeImage(kikurageUserId: String,
                        documentId: String,
                        imageStoragePaths: [String],
                        completion: @escaping (Result<[String], Error>) -> Void) {
        <#code#>
    }
    func getRecipes(kikurageUserId: String,
                    completion: @escaping (Result<[(recipe: KikurageRecipe, documentId: String)], Error>) -> Void) {
        <#code#>
    }
}
// MARK: - Firebase Storage Method
extension RecipeRepository {
    func postRecipeImages(imageData: [Data?],
                          imageStoragePath: String,
                          completion: @escaping (Result<[String], Error>) -> Void) {
        <#code#>
    }
}
