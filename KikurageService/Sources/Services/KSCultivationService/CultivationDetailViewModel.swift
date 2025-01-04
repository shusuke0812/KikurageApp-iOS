//
//  CultivationDetailViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/24.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KUIKit
import KDEntity
import UIKit.UICollectionView

public class CultivationDetailViewModel: NSObject {
    private(set) var cultivation: KikurageCultivation
    private let sectionNumber = 1

    public init(cultivation: KikurageCultivation) {
        self.cultivation = cultivation
    }
}

// MARK: - Config

extension CultivationDetailViewModel {
    public func currentPage(on scrollView: UIScrollView) -> Int {
        let left = scrollView.contentOffset.x
        let width = scrollView.bounds.size.width
        return Int(left / width)
    }
}

// MARK: - UICollectionView DataSource

extension CultivationDetailViewModel: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionNumber
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cultivation.imageStoragePaths.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KUICarouselCollectionViewCell.identifier, for: indexPath) as! KUICarouselCollectionViewCell // swiftlint:disable:this force_cast
        cell.setImage(imageStoragePath: cultivation.imageStoragePaths[indexPath.row])
        return cell
    }
}
