//
//  SettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol SettingViewModelDelegate: AnyObject {
    func settingViewModelDidSuccessGetKikurageUser(_ settingViewModel: SettingViewModel)
    func settingViewModelDidFailedGetKikurageUser(_ settingViewModel: SettingViewModel, with errorMessage: String)
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
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case let .success(kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.delegate?.settingViewModelDidSuccessGetKikurageUser(self!)
            case let .failure(error):
                self?.delegate?.settingViewModelDidFailedGetKikurageUser(self!, with: error.description())
            }
        }
    }
}
