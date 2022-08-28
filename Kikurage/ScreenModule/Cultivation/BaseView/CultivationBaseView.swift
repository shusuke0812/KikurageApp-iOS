//
//  CultivationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationBaseView: UIView {
    @IBOutlet private(set) weak var postPageButton: UIButton!
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        setCollectionView()
    }
}

// MARK: - Initialized

extension CultivationBaseView {
    private func initUI() {
        collectionView.backgroundColor = .systemGroupedBackground
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
}
