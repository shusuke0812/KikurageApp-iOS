//
//  AccountSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KDLoginManager
import KDEntity
import KDRepository
import Foundation

public protocol AccountSettingViewModelDelegate: AnyObject {
    func settingViewModelDidSuccessGetKikurageUser(_ settingViewModel: AccountSettingViewModel)
    func settingViewModelDidFailedGetKikurageUser(_ settingViewModel: AccountSettingViewModel, with errorMessage: String)
}

public class AccountSettingViewModel {
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager

    public weak var delegate: AccountSettingViewModelDelegate?

    public var kikurageUser: KikurageUser?

    public init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
        self.loginManager = LoginManager()
    }
}

// MARK: - Firebase Firestore

extension AccountSettingViewModel {
    public func loadKikurageUser() {
        guard let uid = loginManager.userId else {
            delegate?.settingViewModelDidFailedGetKikurageUser(self, with: "error")
            return
        }
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.delegate?.settingViewModelDidSuccessGetKikurageUser(self!)
            case .failure(let error):
                self?.delegate?.settingViewModelDidFailedGetKikurageUser(self!, with: "error") // TODO: error.description()
            }
        }
    }
}
