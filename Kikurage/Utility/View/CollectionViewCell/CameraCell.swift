//
//  CameraCell.swift
//  Kikurage
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

    weak var delegate: CameraCellDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setDefaultImage()
    }

    // MARK: - Action

    @IBAction private func didTapImageCancelButton(_ sender: Any) {
        delegate?.didTapImageCancelButton(cell: self)
    }
}

// MARK: - Setting Image

extension CameraCell {
    /// デフォルトに戻す（キャンセルボタン押下時）
    func setDefaultImage() {
        cameraIamge.image = R.image.camera()
    }
    /// 選択した画像を表示する（新規選択時）
    /// - Parameter image: 選択した画像
    func setIamge(image: UIImage) {
        cameraIamge.image = image
        cameraIamge.contentMode = .scaleAspectFill
    }
    /// 投稿した画像を表示する（Firebase読み込み時）
    /// - Parameter imageStoragePath: 画像のStorageパス
    func setImage(imageStoragePath: String) {
        if imageStoragePath.isEmpty {
            setDefaultImage()
            return
        }
        let storageReference = Storage.storage().reference(withPath: imageStoragePath)
        cameraIamge.sd_setImage(with: storageReference)
        cameraIamge.contentMode = .scaleAspectFill
    }
}
