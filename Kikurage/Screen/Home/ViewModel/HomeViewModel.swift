//
//  HomeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation
import KikurageFeature
import RxSwift

protocol HomeViewModelInput {
    var kikurageUser: KikurageUser { get }

    func loadKikurageState()
    func listenKikurageState()
}

protocol HomeViewModelOutput {
    var kikurageState: Observable<KikurageState> { get }
    var error: Observable<ClientError> { get }
}

protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol

    private let subject = PublishSubject<KikurageState>()
    private let errorSubject = PublishSubject<ClientError>()
    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    var kikurageUser: KikurageUser
    var kikurageState: Observable<KikurageState> { subject.asObservable() }
    var error: Observable<ClientError> { errorSubject.asObservable() }

    init(kikurageUser: KikurageUser, kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol) {
        self.kikurageUser = kikurageUser

        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageStateListenerRepository = kikurageStateListenerRepository
    }

    deinit {
        KLogger.debug("call deinit")
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
        let request = KikurageStateRequest(productID: kikurageUser.productKey)
        kikurageStateRepository.getKikurageState(request: request)
            .subscribe(
                onSuccess: { [weak self] kikurageState in
                    self?.subject.onNext(kikurageState)
                },
                onFailure: { [weak self] error in
                    let error = error as! ClientError // swiftlint:disable:this force_cast
                    self?.errorSubject.onNext(error)
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
                    let error = error as! ClientError // swiftlint:disable:this force_cast
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
