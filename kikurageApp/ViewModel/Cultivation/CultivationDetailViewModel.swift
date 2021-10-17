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

    private let sectionNumber = 1

    init(cultivation: KikurageCultivation) {
        self.cultivation = cultivation
    }
}
// MARK: - UICollectionView DataSource
extension CultivationDetailViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionNumber
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cultivation.imageStoragePaths.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cultivationCarouselCollectionViewCell, for: indexPath)! // swiftlint:disable:this force_unwrapping
        cell.setUI(cultivationImageStoragePath: cultivation.imageStoragePaths[indexPath.row])
        return cell
    }
}
