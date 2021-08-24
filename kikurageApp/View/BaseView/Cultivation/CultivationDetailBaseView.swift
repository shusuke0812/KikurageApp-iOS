//
//  CultivationDetailBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailBaseView: UIView {
    @IBOutlet private weak var viewDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: CarouselCollectionFlowLayout!
    @IBOutlet private weak var memoTitleLabel: UILabel!
    @IBOutlet private weak var memoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        self.setCollectionView()
    }
}
// MARK: - Initialized
extension CultivationDetailBaseView {
    private func initUI() {
        self.viewDateLabel.text = ""
        self.memoTitleLabel.text = "観察メモ"
        self.memoLabel.text = ""
    }
    private func setCollectionView() {
        self.flowLayout.estimatedItemSize = .zero
        self.collectionView.register(R.nib.cultivationCarouselCollectionViewCell)
    }
}
// MARK: - Setting UI
extension CultivationDetailBaseView {
    func setUI(cultivation: KikurageCultivation) {
        // 観察日の設定
        self.viewDateLabel.text = cultivation.viewDate
        //  観察メモの設定
        self.memoLabel.text = cultivation.memo
    }
}
