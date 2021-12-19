//
//  MainViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol HomeViewModelDelgate: AnyObject {
    /// きくらげの状態データ取得に成功した
    func didSuccessGetKikurageState()
    /// きくらげの状態データ取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageState(errorMessage: String)
    /// きくらげの状態データが更新された
    func didChangedKikurageState()
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
        kikurageStateRepository.getKikurageState(productId: kikurageUser.productKey) { response in
            switch response {
            case .success(let kikurageState):
                DispatchQueue.main.async { [weak self] in
                    self?.kikurageState = kikurageState
                    self?.delegate?.didSuccessGetKikurageState()
                }
            case .failure(let error):
                self.delegate?.didFailedGetKikurageState(errorMessage: error.description())
            }
        }
    }
    /// きくらげの状態をリッスンする
    private func listenKikurageState() {
        kikurageStateListenerRepository.listenKikurageState(productKey: kikurageUser.productKey) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.delegate?.didChangedKikurageState()
            case .failure(let error):
                // TODO: エラーが発生した場合はretryする処理を実装する
                fatalError(error.description())
            }
        }
    }
}
