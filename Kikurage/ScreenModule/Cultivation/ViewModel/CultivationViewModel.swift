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
        cultivation = _cultivation.asObservable()

        let _itemSelected = PublishRelay<IndexPath>()
        itemSelected = AnyObserver<IndexPath> { event in
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
            guard let cultivationDate1 = DateHelper.formatToDate(dateString: cultivation1.data.viewDate) else { return false }
            guard let cultivationDate2 = DateHelper.formatToDate(dateString: cultivation2.data.viewDate) else { return false }
            return cultivationDate1 > cultivationDate2
        }
    }
}

// MARK: - Firebase Firestore

extension CultivationViewModel {
    /// きくらげ栽培記録を読み込む
    func loadCultivations(kikurageUserId: String) {
        let request = KikurageCultivationRequest(kikurageUserId: kikurageUserId)
        cultivationRepository.getCultivations(request: request)
            .subscribe(
                onSuccess: { [weak self] cultivations in
                    guard let `self` = self else { return }
                    let cultivations = self.sortCultivations(cultivations: cultivations)
                    self.subject.onNext(cultivations)
                    // self.subject.onCompleted()
                },
                onFailure: { [weak self] error in
                    self?.subject.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
