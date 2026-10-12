//
//  AccountSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDLoginManager
import KDRepository

protocol AccountSettingViewModelDelegate: AnyObject {
    func settingViewModelDidSuccessGetKikurageUser(_ settingViewModel: AccountSettingViewModel)
    func settingViewModelDidFailedGetKikurageUser(_ settingViewModel: AccountSettingViewModel, with errorMessage: String)
}

class AccountSettingViewModel {
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager

    weak var delegate: AccountSettingViewModelDelegate?
    let state = AccountSettingState()

    private var kikurageUser: KikurageUser?

    init(kikurageUserRepository: KikurageUserRepositoryProtocol = KikurageUserRepository()) {
        self.kikurageUserRepository = kikurageUserRepository
        loginManager = LoginManager()
    }
}

// MARK: - Firebase Firestore

extension AccountSettingViewModel {
    func loadKikurageUser() {
        guard let uid = loginManager.userID else {
            delegate?.settingViewModelDidFailedGetKikurageUser(self, with: "error")
            return
        }
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.state.kikurageName = kikurageUser.kikurageName
                self?.delegate?.settingViewModelDidSuccessGetKikurageUser(self!)
            case .failure(let error):
                self?.delegate?.settingViewModelDidFailedGetKikurageUser(self!, with: error.description())
            }
        }
    }
}
