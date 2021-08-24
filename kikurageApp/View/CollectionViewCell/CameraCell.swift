//
//  CameraCell.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/13.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseUI

protocol CameraCellDelegate: AnyObject {
    /// 画像キャンセルボタンがタップされた時の処理
    /// - Parameter cell: 選択された画像セル
    func didTapImageCancelButton(cell: CameraCell)
}

class CameraCell: UICollectionViewCell {
    @IBOutlet private weak var cameraIamge: UIImageView!
    // デリゲート
    weak var delegate: CameraCellDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDefaultImage()
    }
    // MARK: - Action Method
    @IBAction private func didTapImageCancelButton(_ sender: Any) {
        self.delegate?.didTapImageCancelButton(cell: self)
    }
}
// MARK: - Setting Image Method
extension CameraCell {
    /// デフォルトに戻す（キャンセルボタン押下時）
    func setDefaultImage() {
        self.cameraIamge.image = R.image.camera()
    }
    /// 選択した画像を表示する（新規選択時）
    /// - Parameter image: 選択した画像
    func setIamge(image: UIImage) {
        self.cameraIamge.image = image
        self.cameraIamge.contentMode = .scaleAspectFill
    }
    /// 投稿した画像を表示する（Firebase読み込み時）
    /// - Parameter imageStoragePath: 画像のStorageパス
    func setImage(imageStoragePath: String) {
        if imageStoragePath.isEmpty {
            self.setDefaultImage()
            return
        }
        let storageReference = Storage.storage().reference(withPath: imageStoragePath)
        self.cameraIamge.sd_setImage(with: storageReference)
        self.cameraIamge.contentMode = .scaleAspectFill
    }
}
