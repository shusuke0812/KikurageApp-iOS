//
//  HomeViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDRepository
import KDEntity
import KSFeatures
import RxSwift
import Foundation

public protocol HomeViewModelInput {
    var kikurageUser: KikurageUser { get }

    func loadKikurageState()
    func listenKikurageState()
}

public protocol HomeViewModelOutput {
    var kikurageState: Observable<KikurageState> { get }
    var error: Observable<Error> { get }
    var dateNowString: String { get }
}

public protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

public class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol

    private let subject = PublishSubject<KikurageState>()
    private let errorSubject = PublishSubject<Error>()
    private let disposeBag = DisposeBag()

    public var input: HomeViewModelInput { self }
    public var output: HomeViewModelOutput { self }

    public var kikurageUser: KikurageUser
    public var kikurageState: Observable<KikurageState> { subject.asObservable() }
    public var error: Observable<Error> { errorSubject.asObservable() }
    
    public var dateNowString: String {
        DateHelper.now()
    }

    public init(kikurageUser: KikurageUser, kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol) {
        self.kikurageUser = kikurageUser

        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageStateListenerRepository = kikurageStateListenerRepository
    }

    deinit {
        //KLogger.debug("call deinit")
    }
}

// MARK: - Config

extension HomeViewModel {
    // noting
}

// MARK: - Firebase Firestore

extension HomeViewModel {
    /// きくらげの状態を読み込む
    public func loadKikurageState() {
        let request = KikurageStateRequest(productID: kikurageUser.productKey)
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
    public func listenKikurageState() {
        kikurageStateListenerRepository.listenKikurageState(productKey: kikurageUser.productKey)
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
}
