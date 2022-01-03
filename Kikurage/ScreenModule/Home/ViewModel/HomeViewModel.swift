//
//  MainViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Foundation

protocol HomeViewModelDelgate: AnyObject {
    func homeViewModelDidSuccessGetKikurageState(_ homeViewModel: HomeViewModel)
    func homeViewModelDidFailedGetKikurageState(_ homeViewModel: HomeViewModel, with errorMessage: String)
    func homeViewModelDidChangedKikurageState(_ homeViewModel: HomeViewModel)
}

class HomeViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol

    private(set) var kikurageState: KikurageState!
    private(set) var kikurageUser: KikurageUser!

    weak var delegate: HomeViewModelDelgate?

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageStateListenerRepository = kikurageStateListenerRepository
    }
}

// MARK: - Config

extension HomeViewModel {
    /// きくらげ状態変数とリスナーを設定する
    func config(kikurageUser: KikurageUser?, kikurageState: KikurageState?) {
        self.kikurageUser = kikurageUser
        self.kikurageState = kikurageState

        self.listenKikurageState()
    }
}

// MARK: - Firebase Firestore

extension HomeViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        kikurageStateRepository.getKikurageState(productId: kikurageUser.productKey) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.kikurageState.convertToStateType()
                self?.delegate?.homeViewModelDidSuccessGetKikurageState(self!)
            case .failure(let error):
                self?.kikurageState = nil
                self?.delegate?.homeViewModelDidFailedGetKikurageState(self!, with: error.description())
            }
        }
    }
    /// きくらげの状態をリッスンする
    private func listenKikurageState() {
        kikurageStateListenerRepository.listenKikurageState(productKey: kikurageUser.productKey) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.kikurageState.convertToStateType()
                self?.delegate?.homeViewModelDidChangedKikurageState(self!)
            case .failure(let error):
                self?.kikurageState = nil
                fatalError(error.description())
            }
        }
    }
}
