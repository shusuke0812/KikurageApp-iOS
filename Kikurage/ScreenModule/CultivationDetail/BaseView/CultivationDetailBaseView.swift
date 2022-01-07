//
//  CultivationDetailBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailBaseView: UIView {
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: CarouselCollectionFlowLayout!

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var memoTitleLabel: UILabel!
    @IBOutlet private weak var viewDateLabel: UILabel!
    @IBOutlet private weak var memoTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        setCollectionView()
    }
}

// MARK: - Initialized

extension CultivationDetailBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        viewDateLabel.text = ""
        memoTitleLabel.text = R.string.localizable.screen_cultivation_detail_memo_title()

        memoTextView.text = ""
        memoTextView.clipsToBounds = true
        memoTextView.layer.cornerRadius = .viewCornerRadius
        memoTextView.isEditable = false
        memoTextView.sizeToFit()
        memoTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.layer.borderWidth = 0.5
        iconImageView.layer.borderColor = UIColor.gray.cgColor
    }
    private func setCollectionView() {
        flowLayout.estimatedItemSize = .zero
        collectionView.register(R.nib.cultivationCarouselCollectionViewCell)
    }
}

// MARK: - Config

extension CultivationDetailBaseView {
    func setUI(cultivation: KikurageCultivation) {
        // 観察日の設定
        viewDateLabel.text = cultivation.viewDate
        //  観察メモの設定
        memoTextView.text = cultivation.memo
    }
    func configCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
}
