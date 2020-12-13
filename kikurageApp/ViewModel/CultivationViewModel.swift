//
//  CultivationViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/12.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol CultivationViewModelDelegate: class {
    /// きくらげ栽培記録の取得に成功した
    func didSuccessGetCultivations()
    /// きくらげ栽培記録の取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetCultivations(errorMessage: String)
}
class CultivationViewModel {
    /// きくらげ栽培記録の取得リポジトリ
    private let cultivationRepository: CultivationRepositoryProtocol
    /// デリゲート
    internal weak var delegate: CultivationViewModelDelegate?
    /// きくらげ栽培記録データ
    var cultivations: [(cultivation: KikurageCultivation, documentId: String)] = []
    
    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
    }
}
// MARK: - Firebase Firestore Method
extension CultivationViewModel {
    /// きくらげ栽培記録を読み込む
    func loadCultivations(kikurageUserId: String) {
        self.cultivationRepository
            .getCultivations(kikurageUserId: kikurageUserId,
                             completion: { [weak self] response in
                                switch response {
                                case .success(let cultivations):
                                    self?.cultivations = cultivations
                                case .failure(let error):
                                    self?.delegate?.didFailedGetCultivations(errorMessage: "\(error)")
                                }
                             })
    }
}
