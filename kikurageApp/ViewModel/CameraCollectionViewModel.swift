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
    /// 選択した画像を保持
    /// - Parameters:
    ///   - selectedImage: 選択画像
    ///   - index: CollectionViewのセル番号
    func setImage(selectedImage: UIImage, index: Int) {
        if index >= self.selectedImageMaxNumber {
            print("DEBUG: 指定した配列の要素数よりも大きい要素数です")
            return
        }
        self.selectedImages[index] = selectedImage
    }
    /// 選択した画像をキャンセル
    /// - Parameter index: CollectionViewのセル番号
    func cancelImage(index: Int) {
        if index >= self.selectedImageMaxNumber {
            print("DEBUG: 指定した配列の要素数よりも大きい要素数です")
            return
        }
        self.selectedImages[index] = nil
    }
    /// 画像をData型に変換
    /// - Parameter compresssionQuality: 画像圧縮率 0.0 ~ 1.0
    func changeToImageData(compressionQuality: CGFloat) -> [Data?] {
        let imageDatas: [Data?] = self.selectedImages.map { image in
            image?.jpegData(compressionQuality: compressionQuality)
        }
        return imageDatas
    }
}
// MARK: - CollectionView DataSource Method
extension CameraCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.selectedImageMaxNumber
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath) as! CameraCell // swiftlint:disable:this force_cast
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
