//
//  SettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol AccountSettingViewModelDelegate: AnyObject {
    func settingViewModelDidSuccessGetKikurageUser(_ settingViewModel: AccountSettingViewModel)
    func settingViewModelDidFailedGetKikurageUser(_ settingViewModel: AccountSettingViewModel, with errorMessage: String)
}

class AccountSettingViewModel {
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: AccountSettingViewModelDelegate?

    var kikurageUser: KikurageUser?

    init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Firebase Firestore

extension AccountSettingViewModel {
    func loadKikurageUser(uid: String) {
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.delegate?.settingViewModelDidSuccessGetKikurageUser(self!)
            case .failure(let error):
                self?.delegate?.settingViewModelDidFailedGetKikurageUser(self!, with: error.description())
            }
        }
    }
}
