//
//  MainViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol MainViewModelDelgate: AnyObject {
    /// きくらげの状態データ取得に成功した
    func didSuccessGetKikurageState()
    /// きくらげの状態データ取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageState(errorMessage: String)
    /// きくらげの状態データが更新された
    func didChangedKikurageState()
}

class MainViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol

    var kikurageState: KikurageState!
    var kikurageUser: KikurageUser!

    weak var delegate: MainViewModelDelgate?

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageStateListenerRepository: KikurageStateListenerRepositoryProtocol, kikurageUser: KikurageUser, kikurageState: KikurageState) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageStateListenerRepository = kikurageStateListenerRepository
        self.kikurageUser = kikurageUser
        self.kikurageState = kikurageState
        self.listenKikurageState()
    }
}
// MARK: - Firebase Firestore
extension MainViewModel {
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
