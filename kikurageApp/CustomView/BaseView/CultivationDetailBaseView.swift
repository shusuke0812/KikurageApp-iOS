//
//  CultivationDetailBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailBaseView: UIView {
    
    @IBOutlet weak var viewDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: CarouselCollectionFlowLayout!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
}
// MARK: - Initialized Method
extension CultivationDetailBaseView {
    private func initUI() {
        self.viewDateLabel.text = ""
        self.memoTitleLabel.text = "観察メモ"
        self.memoLabel.text = ""
    }
}
