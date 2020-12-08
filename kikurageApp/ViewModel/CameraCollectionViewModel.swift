//
//  CameraCollectionViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/20.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CameraCollectionViewModel: NSObject {
    // 選択した画像リスト
    private var selectedImages: [UIImage?] = []
    // 選択できる画像数
    var selectedImageMaxNumber: Int
    // CameraCellデリゲート
    internal weak var cameraCellDelegate: CameraCellDelegate?
    
    init(selectedImageMaxNumber: Int) {
        self.selectedImageMaxNumber = selectedImageMaxNumber
        self.selectedImages = Array(repeating: nil, count: selectedImageMaxNumber)
    }
}
// MARK: - Setting Data Method
extension CameraCollectionViewModel {
    func setImageData(selectedImage: UIImage, index: Int) {
        if index >= self.selectedImageMaxNumber {
            print("DEBUG: 指定した配列の要素数よりも大きい要素数です")
            return
        }
        self.selectedImages[index] = selectedImage
    }
    func cancelImageData(index: Int) {
        if index >= self.selectedImageMaxNumber {
            print("DEBUG: 指定した配列の要素数よりも大きい要素数です")
            return
        }
        self.selectedImages[index] = nil
    }
}
// MARK: - CollectionView DataSource Method
extension CameraCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImageMaxNumber
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath) as! CameraCell
        // 各セルのdelegateと管理番号tag（削除用）を設定
        cell.delegate = self.cameraCellDelegate
        cell.tag = indexPath.item
        // 選択された画像の設定
        if let selectedImage = self.selectedImages[indexPath.item] {
            cell.setIamge(image: selectedImage)
        } else {
            cell.setDefaultImage()
        }
        return cell
    }
}
