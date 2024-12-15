//
//  CultivationDetailBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

class CultivationDetailBaseView: UIView {
    private(set) var carouselCollectionView: KUICarouselCollectionView!
    private var contentView: KUICultivationDetailDescriptionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        carouselCollectionView = KUICarouselCollectionView(props: KUICarouselCollectionViewProps())
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false

        contentView = KUICultivationDetailDescriptionView(props: KUICultivationDetailDescriptionViewProps(
            image: R.image.hakase()!,
            tittle: R.string.localizable.screen_cultivation_detail_memo_title(),
            dateString: "-",
            description: "-"
        ))
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(carouselCollectionView)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            carouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 25),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
}

// MARK: - Config

extension CultivationDetailBaseView {
    func setUI(cultivation: KikurageCultivation) {
        contentView.updateMemoDateLabel(dateString: cultivation.viewDate)
        contentView.updateMemoDescription(text: cultivation.memo)
    }

    func configCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        carouselCollectionView.configDelegate(delegate: delegate, dataSource: dataSource)
    }

    func configPageControl(imageCount: Int) {
        carouselCollectionView.setPageControlNumber(imageCount: imageCount)
    }

    func configPageControl(didChangeCurrentPage index: Int) {
        carouselCollectionView.updateCurrentPage(index: index)
    }
}
