//
//  CultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import UIKit.UICollectionView
import Firebase
import RxSwift
import RxCocoa

protocol CultivationViewModelInput {
    var itemSelected: AnyObserver<IndexPath> { get }
}

protocol CultivationViewModelOutput {
    var cultivations: Observable<[KikurageCultivationTuple]> { get }
    var cultivation: Observable<KikurageCultivationTuple> { get }
}

protocol CultivationViewModelType {
    var input: CultivationViewModelInput { get }
    var output: CultivationViewModelOutput { get }
}

class CultivationViewModel: CultivationViewModelType, CultivationViewModelInput, CultivationViewModelOutput {
    private let cultivationRepository: CultivationRepositoryProtocol

    private let disposeBag = RxSwift.DisposeBag()
    private let subject = PublishSubject<[KikurageCultivationTuple]>()

    var input: CultivationViewModelInput { self }
    var output: CultivationViewModelOutput { self }

    let itemSelected: AnyObserver<IndexPath>

    var cultivations: Observable<[KikurageCultivationTuple]> { subject.asObservable() }
    let cultivation: Observable<KikurageCultivationTuple>

    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository

        // for selected collection view item
        let _cultivation = PublishRelay<KikurageCultivationTuple>()
        self.cultivation = _cultivation.asObservable()

        let _itemSelected = PublishRelay<IndexPath>()
        self.itemSelected = AnyObserver<IndexPath> { event in
            guard let indexPath = event.element else {
                return
            }
            _itemSelected.accept(indexPath)
        }

        _itemSelected
            .withLatestFrom(cultivations) { ($0.row, $1) }
            .flatMap { index, cultivations -> Observable<KikurageCultivationTuple> in
                guard index < cultivations.count else {
                    return .empty()
                }
                return .just(cultivations[index])
            }
            .bind(to: _cultivation)
            .disposed(by: disposeBag)
    }
}

// MARK: - Config

extension CultivationViewModel {
    private func sortCultivations(cultivations: [KikurageCultivationTuple]) -> [KikurageCultivationTuple] {
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
