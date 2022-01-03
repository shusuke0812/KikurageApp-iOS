//
//  CultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit.UICollectionView
import Firebase

protocol CultivationViewModelDelegate: AnyObject {
    func cultivationViewModelDidSuccessGetCultivations(_ cultivationViewModel: CultivationViewModel)
    func cultivationViewModelDidFailedGetCultivations(_ cultivationViewModel: CultivationViewModel, with errorMessage: String)
}
class CultivationViewModel: NSObject {
    private let cultivationRepository: CultivationRepositoryProtocol

    weak var delegate: CultivationViewModelDelegate?
    /// きくらげ栽培記録データ
    var cultivations: [(cultivation: KikurageCultivation, documentId: String)] = []

    private let sectionNumber = 1

    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
    }
}

// MARK: - Private

extension CultivationViewModel {
    private func sortCultivations() {
        cultivations.sort { cultivation1, cultivation2 -> Bool in
            guard let cultivationDate1 = DateHelper.formatToDate(dateString: cultivation1.cultivation.viewDate) else { return false }
            guard let cultivationDate2 = DateHelper.formatToDate(dateString: cultivation2.cultivation.viewDate) else { return false }
            return cultivationDate1 > cultivationDate2
        }
    }
}

// MARK: - Firebase Firestore

extension CultivationViewModel {
    /// きくらげ栽培記録を読み込む
    func loadCultivations(kikurageUserId: String) {
        cultivationRepository.getCultivations(kikurageUserId: kikurageUserId) { [weak self] response in
            switch response {
            case .success(let cultivations):
                self?.cultivations = cultivations
                self?.sortCultivations()
                self?.delegate?.cultivationViewModelDidSuccessGetCultivations(self!)
            case .failure(let error):
                self?.delegate?.cultivationViewModelDidFailedGetCultivations(self!, with: error.description())
            }
        }
    }
}

// MARK: - CollectionView DataSource Method

extension CultivationViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionNumber
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cultivations.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cultivationCollectionViewCell, for: indexPath)! // swiftlint:disable:this force_unwrapping
        cell.setUI(cultivation: cultivations[indexPath.row].cultivation)
        return cell
    }
}
