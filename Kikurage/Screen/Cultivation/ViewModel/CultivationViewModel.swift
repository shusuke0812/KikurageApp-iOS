//
//  CultivationViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDLoginManager
import KDRepository
import RxCocoa
import RxSwift

protocol CultivationViewModelInput {
    var itemSelected: AnyObserver<IndexPath> { get }

    func loadCultivations()
}

protocol CultivationViewModelOutput {
    var cultivations: Observable<[KikurageCultivationTuple]> { get }
    var cultivation: Observable<KikurageCultivationTuple> { get }
    var error: Observable<Error> { get }
}

protocol CultivationViewModelType {
    var input: CultivationViewModelInput { get }
    var output: CultivationViewModelOutput { get }
    var state: CultivationState { get }
}

class CultivationViewModel: CultivationViewModelType, CultivationViewModelInput, CultivationViewModelOutput {
    private let cultivationRepository: CultivationRepositoryProtocol
    private let loginManager: LoginManager

    private let disposeBag = RxSwift.DisposeBag()
    private let subject = PublishSubject<[KikurageCultivationTuple]>()
    private let errorSubject = PublishSubject<Error>()

    var input: CultivationViewModelInput { self }
    var output: CultivationViewModelOutput { self }
    let state = CultivationState()

    let itemSelected: AnyObserver<IndexPath>

    var cultivations: Observable<[KikurageCultivationTuple]> { subject.asObservable() }
    let cultivation: Observable<KikurageCultivationTuple>
    var error: Observable<Error> { errorSubject.asObserver() }

    init(cultivationRepository: CultivationRepositoryProtocol = CultivationRepository()) {
        self.cultivationRepository = cultivationRepository
        loginManager = LoginManager()

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
    func loadCultivations() {
        guard let userID = loginManager.userID else {
            // errorSubject.onNext() // TODO: Error型を定義してVCに通知する
            return
        }
        let request = KikurageCultivationRequest(kikurageUserID: userID)
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
