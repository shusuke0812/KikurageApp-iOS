//
//  HomeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDRepository
import RxSwift

protocol HomeViewModelInput {
    var productKey: String { get }
    var userId: String { get }

    func loadKikurageState()
    func listenKikurageState()
    func loadKikurageName()
}

protocol HomeViewModelOutput {
    var kikurageState: Observable<KikurageState> { get }
    var error: Observable<Error> { get }
    var dateNowString: String { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
    var state: HomeState { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol

    private let subject = PublishSubject<KikurageState>()
    private let errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }
    let state = HomeState()

    let productKey: String
    let userId: String
    var kikurageState: Observable<KikurageState> { subject.asObservable() }
    var error: Observable<Error> { errorSubject.asObservable() }

    var dateNowString: String {
        DateHelper.now()
    }

    init(
        productKey: String,
        userId: String,
        kikurageStateRepository: KikurageStateRepositoryProtocol = KikurageStateRepository(),
        kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol = KikurageStateListenerRepository()
    ) {
        self.productKey = productKey
        self.userId = userId

        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageStateListenerRepository = kikurageStateListenerRepository
    }

    deinit {
        // KLogger.debug("call deinit")
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
        let request = KikurageStateRequest(productID: productKey)
        kikurageStateRepository.getKikurageState(request: request)
            .subscribe(
                onSuccess: { [weak self] kikurageState in
                    self?.subject.onNext(kikurageState)
                },
                onFailure: { [weak self] error in
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }

    /// きくらげの状態をリッスンする
    func listenKikurageState() {
        kikurageStateListenerRepository.listenKikurageState(productKey: productKey)
            .subscribe(
                onNext: { [weak self] kikurageState in
                    self?.subject.onNext(kikurageState)
                },
                onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }

    /// きくらげの名前を読み込む
    func loadKikurageName() {
        // TODO: userIdを使ったKikurageUser取得処理を実装する（本タスクのスコープ外）
    }
}
