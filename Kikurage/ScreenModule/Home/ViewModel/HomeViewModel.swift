//
//  MainViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelInput {
    var kikurageUser: KikurageUser { get }
}

protocol HomeViewModelOutput {
    var kikurageState: Observable<KikurageState> { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol

    private let subject = PublishSubject<KikurageState>()
    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    var kikurageUser: KikurageUser
    var kikurageState: Observable<KikurageState> { subject.asObservable() }

    init(kikurageUser: KikurageUser, kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol) {
        self.kikurageUser = kikurageUser

        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageStateListenerRepository = kikurageStateListenerRepository
    }
}

// MARK: - Config

extension HomeViewModel {
    // noting
}

// MARK: - Firebase Firestore

extension HomeViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        kikurageStateRepository.getKikurageState(productId: kikurageUser.productKey)
            .subscribe(
                onSuccess: { [weak self] kikurageState in
                    self?.subject.onNext(kikurageState)
                },
                onFailure: { [weak self] error in
                    self?.subject.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    /// きくらげの状態をリッスンする
    func listenKikurageState() {
        kikurageStateListenerRepository.listenKikurageState(productKey: kikurageUser.productKey)
            .subscribe(
                onNext: { [weak self] kikurageState in
                    self?.subject.onNext(kikurageState)
                },
                onError: { [weak self] error in
                    self?.subject.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
