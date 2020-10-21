//
//  MainViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol MainViewModelDelgate: class {
    /// きくらげの状態データ取得に成功した
    func didSuccessGetKikurageState()
    /// きくらげの状態データ取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageState(errorMessage: String)
}

class MainViewModel {
    /// きくらげの状態取得リポジトリ
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    /// きくらげの状態
    internal var kikurageState: KikurageState?
    /// デリゲート
    internal weak var delegate: MainViewModelDelgate?
    
    init(kikurageStateRepository: KikurageStateRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
    }
}

extension MainViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        self.kikurageStateRepository.getKikurageState(
            uid: "BFwAuLtNWTg3YKhOqYsj",
            completion: { response in
                switch response {
                case .success(let kikurageState):
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.kikurageState = kikurageState
                        self?.delegate?.didSuccessGetKikurageState()
                    }
                case .failure(let error):
                    print("DEBUG: \(error)")
                    self.delegate?.didFailedGetKikurageState(errorMessage: "きくらげの状態を取得できませんでした")
                }
            })
    }
}
