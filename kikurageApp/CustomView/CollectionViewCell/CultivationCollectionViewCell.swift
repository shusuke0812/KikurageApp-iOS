//
//  CultivationCollectionViewCell.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CultivationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
}
// MARK: - Initialized Method
extension CultivationCollectionViewCell {
    private func initUI() {
        self.viewDateLabel.text = ""
        self.imageView.backgroundColor = .lightGray
    }
    func setUI(cultivation: KikurageCultivation) {
        // 画像を設定
        let imageStoragePath = cultivation.imageStoragePaths[0]
        if !imageStoragePath.isEmpty {
            let storageReference = Storage.storage().reference(withPath: imageStoragePath)
            self.imageView.sd_setImage(with: storageReference)
        }
        // 日付を設定
        self.viewDateLabel.text = cultivation.viewDate
    }
}
