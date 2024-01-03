//
//  AppPresenter.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/4.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Firebase
import Foundation
import KikurageFeature

protocol AppPresenterDelegate: AnyObject {
    /// きくらげ情報の取得に成功した
    func didSuccessGetKikurageInfo(kikurageInfo: (user: KikurageUser?, state: KikurageState?))
    /// きくらげ情報の取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageInfo(errorMessage: String)
}

class AppPresenter {
    private let firebaseRemoteCofigRepository: FirebaseRemoteConfigRepositoryProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol

    weak var delegate: AppPresenterDelegate?

    init(firebaseRemoteCofigRepository: FirebaseRemoteConfigRepositoryProtocol) {
        self.firebaseRemoteCofigRepository = firebaseRemoteCofigRepository
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
    }
}

// MARK: - Firebase Firestore

extension AppPresenter {
    func login() {
        let userID = LoginHelper.shared.kikurageUserID ?? ""
        loadKikurageStateWithUserUseCase.invoke(uid: userID) { [weak self] responses in
            switch responses {
            case .success(let res):
                self?.delegate?.didSuccessGetKikurageInfo(kikurageInfo: (user: res.user, state: res.state))
            case .failure(let error):
                self?.delegate?.didFailedGetKikurageInfo(errorMessage: error.description())
            }
        }
    }
}

// MARK: - Firebase RemoteConfig

extension AppPresenter {
    func loadFacebookGroupURL() {
        firebaseRemoteCofigRepository.fetch(key: .facebookGroupURL) { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.facebookGroupURL = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Facebook Group Url from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadTermsURL() {
        firebaseRemoteCofigRepository.fetch(key: .termsURL) { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.termsURL = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Terms Url from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadPrivacyPolicyURL() {
        firebaseRemoteCofigRepository.fetch(key: .privacyPolicyURL) { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.privacyPolicyURL = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Privacy Policy Url from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadLatestAppVersion() {
        firebaseRemoteCofigRepository.fetch(key: .latestAppVersion) { response in
            switch response {
            case .success(let appVersionString):
                let appVersion = AppVersion(versionString: appVersionString)
                AppConfig.shared.latestAppVersion = appVersion
            case .failure(let error):
                KLogManager.debug("Failed to get iOS App Version from Remote Config : " + error.localizedDescription)
            }
        }
    }
}
