//
//  CultivationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

class CultivationBaseView: UIView {
    private(set) var collectionView: UICollectionView!
    private(set) var postPageButton: KUICircleButton!

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRefreshControlInCollectionView(_ refresh: UIRefreshControl) {
        collectionView.refreshControl = refresh
    }

    private func setupComponent() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = .zero
        flowLayout.minimumLineSpacing = .cellSpacing * 2
        flowLayout.minimumInteritemSpacing = .cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: .cellSpacing, left: .cellSpacing, bottom: .cellSpacing, right: .cellSpacing)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(KUICultivationCollectionViewCell.self, forCellWithReuseIdentifier: KUICultivationCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        postPageButton = KUICircleButton(props: KUICircleButtonProps(
            variant: .primary,
            image: R.image.addMemoButton(),
            width: 60
        ))
        postPageButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)
        addSubview(postPageButton)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            postPageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            postPageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
