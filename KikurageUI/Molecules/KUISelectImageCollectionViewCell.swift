//
//  KUISelectImageCollectionViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/7.
//  Copyright © 2024 shusuke. All rights reserved.
//

import FirebaseStorageUI
import UIKit

public protocol KUISelectImageCollectionViewCellDelegate: AnyObject {
    func didTapImageCancelButton(cell: KUISelectImageCollectionViewCell)
}

public class KUISelectImageCollectionViewCell: UICollectionViewCell {
    public static let identifier = "CameraCell"
    public weak var delegate: KUISelectImageCollectionViewCellDelegate?

    private var selectImageView: UIImageView!
    private var cancelButton: UIButton!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupAction()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// デフォルトに戻す（キャンセルボタン押下時）
    public func setDefaultImage() {
        selectImageView.image = R.image.camera()
    }

    /// 選択した画像を表示する（新規選択時）
    /// - Parameter image: 選択した画像
    public func setIamge(image: UIImage) {
        selectImageView.image = image
        selectImageView.contentMode = .scaleAspectFill
    }

    /// 投稿した画像を表示する（Firebase読み込み時）
    /// - Parameter imageStoragePath: 画像のStorageパス
    public func setImage(imageStoragePath: String) {
        if imageStoragePath.isEmpty {
            setDefaultImage()
            return
        }
        let storageReference = Storage.storage().reference(withPath: imageStoragePath)
        selectImageView.sd_setImage(with: storageReference)
        selectImageView.contentMode = .scaleAspectFill
    }

    private func setupComponent() {
        selectImageView = UIImageView(image: UIImage(named: "camera"))
        selectImageView.contentMode = .scaleAspectFill
        selectImageView.translatesAutoresizingMaskIntoConstraints = false

        cancelButton = UIButton()
        cancelButton.tintColor = .darkGray
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(selectImageView)
        contentView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            selectImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            cancelButton.widthAnchor.constraint(equalToConstant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupAction() {
        cancelButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.didTapImageCancelButton(cell: self)
        }, for: .touchUpInside)
    }
}

public class KUISelectImageCollectionViewModel: NSObject {
    private var selectedImages: [UIImage?] = []
    private let selectedImageMaxNumber: Int

    public weak var collectionViewDelegate: KUISelectImageCollectionViewCellDelegate?

    public init(selectedImageMaxNumber: Int, collectionViewDelegate: KUISelectImageCollectionViewCellDelegate?) {
        self.selectedImageMaxNumber = selectedImageMaxNumber
        selectedImages = Array(repeating: nil, count: selectedImageMaxNumber)
        self.collectionViewDelegate = collectionViewDelegate
    }

    public func setImage(selectedImage: UIImage, index: Int) {
        if index >= selectedImageMaxNumber {
            return
        }
        selectedImages[index] = selectedImage
    }

    public func cancelImage(index: Int) {
        if index >= selectedImageMaxNumber {
            return
        }
        selectedImages[index] = nil
    }

    /// 画像をData型に変換
    /// - Parameter compresssionQuality: 画像圧縮率 0.0 ~ 1.0
    public func changeToImageData(compressionQuality: CGFloat) -> [Data?] {
        let imageDatas: [Data?] = selectedImages.map { image in
            image?.jpegData(compressionQuality: compressionQuality)
        }
        return imageDatas
    }
}

extension KUISelectImageCollectionViewModel: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedImageMaxNumber
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KUISelectImageCollectionViewCell.identifier, for: indexPath) as! KUISelectImageCollectionViewCell // swiftlint:disable:this force_cast
        // 各セルのdelegateと管理番号tag（削除用）を設定
        cell.delegate = collectionViewDelegate
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
