//
//  CultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import Foundation
import RxCocoa
import RxSwift
import UIKit.UICollectionView

protocol CultivationViewModelInput {
    var itemSelected: AnyObserver<IndexPath> { get }

    func loadCultivations(kikurageUserID: String)
}

protocol CultivationViewModelOutput {
    var cultivations: Observable<[KikurageCultivationTuple]> { get }
    var cultivation: Observable<KikurageCultivationTuple> { get }
    var error: Observable<ClientError> { get }
}

protocol CultivationViewModelType {
    var input: CultivationViewModelInput { get }
    var output: CultivationViewModelOutput { get }
}

class CultivationViewModel: CultivationViewModelType, CultivationViewModelInput, CultivationViewModelOutput {
    private let cultivationRepository: CultivationRepositoryProtocol

    private let disposeBag = RxSwift.DisposeBag()
    private let subject = PublishSubject<[KikurageCultivationTuple]>()
    private let errorSubject = PublishSubject<ClientError>()

    var input: CultivationViewModelInput { self }
    var output: CultivationViewModelOutput { self }

    let itemSelected: AnyObserver<IndexPath>

    var cultivations: Observable<[KikurageCultivationTuple]> { subject.asObservable() }
    let cultivation: Observable<KikurageCultivationTuple>
    var error: Observable<ClientError> { errorSubject.asObserver() }

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
            guard let cultivationDate1 = DateHelper.formatToDate(dateString: cultivation1.data.viewDate) else {
                return false
            }
            guard let cultivationDate2 = DateHelper.formatToDate(dateString: cultivation2.data.viewDate) else {
                return false
            }
            return cultivationDate1 > cultivationDate2
        }
    }
}

// MARK: - Firebase Firestore

extension CultivationViewModel {
    /// きくらげ栽培記録を読み込む
    func loadCultivations(kikurageUserID: String) {
        let request = KikurageCultivationRequest(kikurageUserID: kikurageUserID)
        cultivationRepository.getCultivations(request: request)
            .subscribe(
                onSuccess: { [weak self] cultivations in
                    guard let `self` = self else {
                        return
                    }
                    let _cultivations = self.sortCultivations(cultivations: cultivations)
                    self.subject.onNext(_cultivations)
                },
                onFailure: { [weak self] error in
                    let _error = error as! ClientError // swiftlint:disable:this force_cast
                    self?.errorSubject.onNext(_error)
                }
            )
            .disposed(by: disposeBag)
    }
}
