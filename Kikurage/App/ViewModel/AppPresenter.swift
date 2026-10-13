//
//  AppPresenter.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2025/1/1.
//

import Foundation
import KALogger
import KDEntity
import KDLoginManager
import KDRepository
import KDUseCase

protocol AppPresenterDelegate: AnyObject {
    func appPresenterDidSuccessGetKikurageInfo(_ appPresenter: AppPresenter?, user: KikurageUser?)
    func appPresenterDidFailedGetKikurageInfo(_ appPresenter: AppPresenter?, errorMessage: String)
}

class AppPresenter {
    var isLogin: Bool {
        loginManager.isLogin
    }

    private let appConfigRepository: AppConfigRepositoryProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol
    private let loginManager: LoginManager

    weak var delegate: AppPresenterDelegate?

    init(
        appConfigRepository: AppConfigRepositoryProtocol = AppConfigRepository()
    ) {
        self.appConfigRepository = appConfigRepository
        loginManager = LoginManager()
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
    }

    func login() {
        let userID = loginManager.userID ?? ""
        loadKikurageStateWithUserUseCase.invoke(uid: userID) { [weak self] result in
            switch result {
            case .success(let res):
                self?.delegate?.appPresenterDidSuccessGetKikurageInfo(self, user: res.user)
            case .failure(let error):
                self?.delegate?.appPresenterDidFailedGetKikurageInfo(self, errorMessage: error.description())
            }
        }
    }

    func loadFacebookGroupURL() {
        appConfigRepository.getFacebookGroupURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.facebookGroupURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Facebook Group URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadTermsURL() {
        appConfigRepository.getTermsURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.termsURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Terms URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadPrivacyPolicyURL() {
        appConfigRepository.getPrivacyPolicyURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.privacyPolicyURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Privacy Policy URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadLatestAppVersion() {
        appConfigRepository.getLatestAppVersion { response in
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
