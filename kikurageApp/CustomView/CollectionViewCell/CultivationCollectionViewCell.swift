//
//  CultivationCollectionViewCell.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

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
}
