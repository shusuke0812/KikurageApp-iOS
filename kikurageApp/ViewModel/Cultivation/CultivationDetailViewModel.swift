//
//  CultivationDetailViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/24.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailViewModel: NSObject {
    /// きくらげ 栽培記録データ
    var cultivation: KikurageCultivation
    /// セクション数
    private let sectionNumber = 1

    init(cultivation: KikurageCultivation) {
        self.cultivation = cultivation
    }
}
// MARK: - UICollectionView DataSource Method
extension CultivationDetailViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.sectionNumber
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.cultivation.imageStoragePaths.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CultivationCarouselCollectionViewCell", for: indexPath) as! CultivationCarouselCollectionViewCell // swiftlint:disable:this force_cast
        cell.setUI(cultivationImageStoragePath: self.cultivation.imageStoragePaths[indexPath.row])
        return cell
    }
}
