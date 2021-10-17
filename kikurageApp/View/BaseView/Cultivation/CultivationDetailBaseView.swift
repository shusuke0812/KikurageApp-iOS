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
        initUI()
        setCollectionView()
    }
}
// MARK: - Initialized
extension CultivationDetailBaseView {
    private func initUI() {
        viewDateLabel.text = ""
        memoTitleLabel.text = "観察メモ"
        memoLabel.text = ""
    }
    private func setCollectionView() {
        flowLayout.estimatedItemSize = .zero
        collectionView.register(R.nib.cultivationCarouselCollectionViewCell)
    }
}
// MARK: - Setting UI
extension CultivationDetailBaseView {
    func setUI(cultivation: KikurageCultivation) {
        // 観察日の設定
        viewDateLabel.text = cultivation.viewDate
        //  観察メモの設定
        memoLabel.text = cultivation.memo
    }
}
