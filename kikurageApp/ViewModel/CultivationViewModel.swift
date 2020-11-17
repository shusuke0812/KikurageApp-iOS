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
    func didSuccessGetKikurageUserCultivations()
    /// きくらげ栽培記録の取得に失敗した
    func didFailedGetKikurageUserCultivations()
}
class CultivationViewModel {
    /// きくらげ栽培記録の取得リポジトリ
    //private let kikurageUserCultivationRepository: KikurageUserCultivationRepositoryProtocol
    /// デリゲート
    internal weak var delegate: CultivationViewModelDelegate?
    /*
    init(kikurageUserCultivationRepository: KikurageUserCultivationRepositoryProtocol) {
        self.kikurageUserCultivationRepository = kikurageUserCultivationRepository
    }
    */
}
extension CultivationViewModel {
    /// きくらげ栽培記録を読み込む
    func loadKikurageUserCultivations(kikurageUserId: String) {
    }
}
