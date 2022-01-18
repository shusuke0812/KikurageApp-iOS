//
//  CultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit.UICollectionView
import Firebase
import RxSwift

protocol CultivationViewModelInput {}

protocol CultivationViewModelOutput {
    var cultivations: Observable<[(cultivation: KikurageCultivation, documentId: String)]> { get }
}

protocol CultivationViewModelType {
    var input: CultivationViewModelInput { get }
    var output: CultivationViewModelOutput { get }
}

class CultivationViewModel: CultivationViewModelType, CultivationViewModelInput, CultivationViewModelOutput {
    private let cultivationRepository: CultivationRepositoryProtocol

    private let subject = PublishSubject<[(cultivation: KikurageCultivation, documentId: String)]>()

    var input: CultivationViewModelInput { self }
    var output: CultivationViewModelOutput { self }

    var cultivations: Observable<[(cultivation: KikurageCultivation, documentId: String)]> { subject.asObservable() }

    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
    }
}

// MARK: - Config

extension CultivationViewModel {
    private func sortCultivations(cultivations: [(cultivation: KikurageCultivation, documentId: String)]) -> [(cultivation: KikurageCultivation, documentId: String)] {
        cultivations.sorted { cultivation1, cultivation2 -> Bool in
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
            guard let `self` = self else {
                self?.subject.onError(ClientError.unknown)
                return
            }
            switch response {
            case .success(let cultivations):
                Logger.verbose("\(cultivations)")
                let cultivations = self.sortCultivations(cultivations: cultivations)
                self.subject.onNext(cultivations)
            case .failure(let error):
                Logger.verbose(error.localizedDescription)
                self.subject.onError(error)
            }
        }
    }
}
