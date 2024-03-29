//
//  CameraCollectionViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/20.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CameraCollectionViewModel: NSObject {
    /// 選択した画像リスト
    private var selectedImages: [UIImage?] = []
    /// 選択できる画像数
    var selectedImageMaxNumber: Int

    weak var cameraCellDelegate: CameraCellDelegate?

    init(selectedImageMaxNumber: Int) {
        self.selectedImageMaxNumber = selectedImageMaxNumber
        selectedImages = Array(repeating: nil, count: selectedImageMaxNumber)
    }
}

// MARK: - Setting Data

extension CameraCollectionViewModel {
    /// 選択した画像を保持
    /// - Parameters:
    ///   - selectedImage: 選択画像
    ///   - index: CollectionViewのセル番号
    func setImage(selectedImage: UIImage, index: Int) {
        if index >= selectedImageMaxNumber {
            return
        }
        selectedImages[index] = selectedImage
    }

    /// 選択した画像をキャンセル
    /// - Parameter index: CollectionViewのセル番号
    func cancelImage(index: Int) {
        if index >= selectedImageMaxNumber {
            return
        }
        selectedImages[index] = nil
    }

    /// 画像をData型に変換
    /// - Parameter compresssionQuality: 画像圧縮率 0.0 ~ 1.0
    func changeToImageData(compressionQuality: CGFloat) -> [Data?] {
        let imageDatas: [Data?] = selectedImages.map { image in
            image?.jpegData(compressionQuality: compressionQuality)
        }
        return imageDatas
    }
}

// MARK: - CollectionView DataSource

extension CameraCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedImageMaxNumber
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cameraCell, for: indexPath)! // swiftlint:disable:this force_unwrapping
        // 各セルのdelegateと管理番号tag（削除用）を設定
        cell.delegate = cameraCellDelegate
        cell.tag = indexPath.item
        // 選択された画像の設定
        if let selectedImage = selectedImages[indexPath.item] {
            cell.setIamge(image: selectedImage)
        } else {
            cell.setDefaultImage()
        }
        return cell
    }
}
