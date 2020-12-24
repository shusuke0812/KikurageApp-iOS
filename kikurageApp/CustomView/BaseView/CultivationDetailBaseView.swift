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
        self.setCollectionView()
    }
}
// MARK: - Initialized Method
extension CultivationDetailBaseView {
    private func initUI() {
        self.viewDateLabel.text = ""
        self.memoTitleLabel.text = "観察メモ"
        self.memoLabel.text = ""
    }
    private func setCollectionView() {
        self.flowLayout.estimatedItemSize = .zero
        self.collectionView.register(UINib(nibName: "CultivationCarouselCollectionView", bundle: nil), forCellWithReuseIdentifier: "CultivationCarouselCollectionView")
    }
}
// MARK: - Setting UI Method
extension CultivationDetailBaseView {
    func setUI(cultivation: KikurageCultivation) {
        // 観察日の設定
        self.viewDateLabel.text = cultivation.viewDate
        //  観察メモの設定
        self.memoLabel.text = cultivation.memo
    }
}
