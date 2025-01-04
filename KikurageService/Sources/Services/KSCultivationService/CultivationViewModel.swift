//
//  CultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDRepository
import KDEntity
import KSFeatures
import Foundation
import RxSwift
import RxCocoa
import UIKit.UICollectionView

public protocol CultivationViewModelInput {
    var itemSelected: AnyObserver<IndexPath> { get }

    func loadCultivations(kikurageUserID: String)
}

public protocol CultivationViewModelOutput {
    var cultivations: Observable<[KikurageCultivationTuple]> { get }
    var cultivation: Observable<KikurageCultivationTuple> { get }
    var error: Observable<Error> { get }
}

public protocol CultivationViewModelType {
    var input: CultivationViewModelInput { get }
    var output: CultivationViewModelOutput { get }
}

public class CultivationViewModel: CultivationViewModelType, CultivationViewModelInput, CultivationViewModelOutput {
    private let cultivationRepository: CultivationRepositoryProtocol

    private let disposeBag = RxSwift.DisposeBag()
    private let subject = PublishSubject<[KikurageCultivationTuple]>()
    private let errorSubject = PublishSubject<Error>()

    public var input: CultivationViewModelInput { self }
    public var output: CultivationViewModelOutput { self }

    public let itemSelected: AnyObserver<IndexPath>

    public var cultivations: Observable<[KikurageCultivationTuple]> { subject.asObservable() }
    public let cultivation: Observable<KikurageCultivationTuple>
    public var error: Observable<Error> { errorSubject.asObserver() }

    public init(cultivationRepository: CultivationRepositoryProtocol) {
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
    public func loadCultivations(kikurageUserID: String) {
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
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
