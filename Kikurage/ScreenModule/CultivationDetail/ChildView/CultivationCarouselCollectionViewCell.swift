//
//  CultivationCarouselCollectionViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/24.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestore
import KikurageFeature
import UIKit

class CultivationCarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var kikurageImageView: KikurageImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

// MARK: - Initialized

extension CultivationCarouselCollectionViewCell {
    private func initUI() {}
}

// MARK: - Setting UI

extension CultivationCarouselCollectionViewCell {
    func setUI(cultivationImageStoragePath: String) {
        let storageReference = Storage.storage().reference(withPath: cultivationImageStoragePath)
        kikurageImageView.imageView.sd_setImage(with: storageReference, placeholderImage: nil)
    }
}
