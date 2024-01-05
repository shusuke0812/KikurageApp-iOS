//
//  CultivationCollectionViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import FirebaseStorageUI
import KikurageFeature
import UIKit

class CultivationCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var viewDateLabel: UILabel!
    @IBOutlet private weak var loadingThumbnailView: LoadingThumbnailView!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

// MARK: - Initialized

extension CultivationCollectionViewCell {
    private func initUI() {
        viewDateLabel.text = ""

        clipsToBounds = true
        layer.cornerRadius = .cellCornerRadius
    }
}

// MARK: - Setting UI

extension CultivationCollectionViewCell {
    func setUI(cultivation: KikurageCultivation) {
        guard let imageStoragePath = cultivation.imageStoragePaths.first else {
            return
        }
        if !imageStoragePath.isEmpty {
            let storageReference = Storage.storage().reference(withPath: imageStoragePath)
            imageView.sd_setImage(with: storageReference, placeholderImage: nil) { [weak self] _, error, _, _ in
                if let error = error {
                    KLogger.verbose(error.localizedDescription)
                    return
                }
                self?.viewDateLabel.text = cultivation.viewDate
            }
        }
    }
}
