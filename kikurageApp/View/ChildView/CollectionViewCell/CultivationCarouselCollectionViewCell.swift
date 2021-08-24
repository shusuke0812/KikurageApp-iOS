//
//  CultivationCarouselCollectionViewCell.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/24.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CultivationCarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
}
// MARK: - Initialized
extension CultivationCarouselCollectionViewCell {
    private func initUI() {
        self.imageView.backgroundColor = .lightGray
    }
}
// MARK: - Setting UI
extension CultivationCarouselCollectionViewCell {
    func setUI(cultivationImageStoragePath: String) {
        let storageReference = Storage.storage().reference(withPath: cultivationImageStoragePath)
        self.imageView.sd_setImage(with: storageReference, placeholderImage: Constants.Image.loading)
    }
}
