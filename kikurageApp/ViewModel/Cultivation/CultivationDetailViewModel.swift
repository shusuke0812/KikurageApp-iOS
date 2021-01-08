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
    
    init(cultivation: KikurageCultivation) {
        self.cultivation = cultivation
    }
}
// MARK: - UICollectionView DataSource Method
extension CultivationDetailViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cultivation.imageStoragePaths.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CultivationCarouselCollectionViewCell", for: indexPath) as! CultivationCarouselCollectionViewCell
        cell.setUI(cultivationImageStoragePath: self.cultivation.imageStoragePaths[indexPath.row])
        return cell
    }
}
