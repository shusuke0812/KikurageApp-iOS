//
//  SettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol SettingViewModelDelegate: AnyObject {
    /// きくらげユーザーの取得に成功した
    func didSuccessGetKikurageUser()
    /// きくらげユーザーの取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageUser(errorMessage: String)
}

class SettingViewModel {
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: SettingViewModelDelegate?

    var kikurageUser: KikurageUser?

    init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Firebase Firestore

extension SettingViewModel {
    func loadKikurageUser(uid: String) {
        kikurageUserRepository.getKikurageUser(uid: uid) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.delegate?.didSuccessGetKikurageUser()
            case .failure(let error):
                self?.delegate?.didFailedGetKikurageUser(errorMessage: error.description())
            }
        }
    }
}
