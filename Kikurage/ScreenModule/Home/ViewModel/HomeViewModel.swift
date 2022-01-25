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
        kikurageStateRepository.getKikurageState(productId: kikurageUser.productKey) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                Logger.verbose("\(kikurageState)")
                self?.subject.onNext(kikurageState)
                self?.subject.onCompleted()
            case .failure(let error):
                Logger.verbose(error.localizedDescription)
                self?.subject.onError(error)
            }
        }
    }
    /// きくらげの状態をリッスンする
    func listenKikurageState() {
        kikurageStateListenerRepository.listenKikurageState(productKey: kikurageUser.productKey) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                Logger.verbose("\(kikurageState)")
                self?.subject.onNext(kikurageState)
                self?.subject.onCompleted()
            case .failure(let error):
                Logger.verbose(error.localizedDescription)
                self?.subject.onError(error)
            }
        }
    }
}
