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

    @IBOutlet private weak var pageControl: UIPageControl!

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

        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.pageIndicatorTintColor = .white
    }

    private func setCollectionView() {
        flowLayout.estimatedItemSize = .zero
        collectionView.register(R.nib.cultivationCarouselCollectionViewCell)
        collectionView.showsHorizontalScrollIndicator = false
    }
}

// MARK: - Config

extension CultivationDetailBaseView {
    func setUI(cultivation: KikurageCultivation) {
        viewDateLabel.text = cultivation.viewDate
        memoTextView.text = cultivation.memo
    }

    func configCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }

    func configPageControl(imageCount: Int) {
        if imageCount <= 1 {
            pageControl.numberOfPages = 0
        } else {
            pageControl.numberOfPages = imageCount
        }
    }

    func configPageControl(didChangedCurrentPage index: Int) {
        pageControl.currentPage = index
    }
}
