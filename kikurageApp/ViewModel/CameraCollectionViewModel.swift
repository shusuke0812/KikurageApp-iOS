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
    // デリゲート
    internal weak var delegate: CameraCellDelegate?
    
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
}
// MARK: - CollectionView DataSource Method
extension CameraCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImageMaxNumber
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath) as! CameraCell
        if let selectedImage = self.selectedImages[indexPath.item] {
            cell.setIamge(image: selectedImage)
        }
        return cell
    }
}
