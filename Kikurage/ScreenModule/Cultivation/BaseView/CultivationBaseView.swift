//
//  CultivationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol CultivationBaseViewDelegate: AnyObject {
    func cultivationBaseViewDidTapPostCultivationPageButton(_ cultivationBaseView: CultivationBaseView)
}

class CultivationBaseView: UIView {
    @IBOutlet private weak var postPageButton: UIButton!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet private weak var noCultivationLabel: UILabel!

    weak var delegate: CultivationBaseViewDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        setCollectionView()
    }

    // MARK: - Action

    @IBAction private func openCultivationPost(_ sender: Any) {
        delegate?.cultivationBaseViewDidTapPostCultivationPageButton(self)
    }
}

// MARK: - Initialized

extension CultivationBaseView {
    private func initUI() {
        collectionView.backgroundColor = .systemGroupedBackground

        noCultivationLabel.text = R.string.localizable.screen_cultivation_no_cultivation()
        noCultivationLabel.textColor = .darkGray
        noCultivationLabel.isHidden = true
    }
    private func setCollectionView() {
        flowLayout.estimatedItemSize = .zero
        flowLayout.minimumLineSpacing = .cellSpacing * 2
        flowLayout.minimumInteritemSpacing = .cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: .cellSpacing, left: .cellSpacing, bottom: .cellSpacing, right: .cellSpacing)
        collectionView.register(R.nib.cultivationCollectionViewCell)
    }
}

// MARK: - Config

extension CultivationBaseView {
    func setRefreshControlInCollectionView(_ refresh: UIRefreshControl) {
        collectionView.refreshControl = refresh
    }
    func configColletionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    func noCultivationLabelIsHidden(_ isHidden: Bool) {
        noCultivationLabel.isHidden = isHidden
    }
}
