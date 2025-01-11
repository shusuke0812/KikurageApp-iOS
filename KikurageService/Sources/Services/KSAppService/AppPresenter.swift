//
//  AppPresenter.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/1.
//

import Foundation
import KALogger
import KDLoginManager
import KDRepository
import KSSLoadKikurageStateUseCase

@_exported import KDEntity

public protocol AppPresenterDelegate: AnyObject {
    func appPresenterDidSuccessGetKikurageInfo(_ appPresenter: AppPresenter?, kikurageInfo: (user: KikurageUser?, state: KikurageState?))
    func appPresenterDidFailedGetKikurageInfo(_ appPresenter: AppPresenter?, errorMessage: String)
}

public class AppPresenter {
    public var isLogin: Bool {
        loginManager.isLogin
    }

    private let appConfigRepository: AppConfigRepositoryProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol
    private let loginManager: LoginManager

    public weak var delegate: AppPresenterDelegate?

    public init(
        appConfigRepository: AppConfigRepositoryProtocol = AppConfigRepository()
    ) {
        self.appConfigRepository = appConfigRepository
        loginManager = LoginManager()
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
    }

    public func login() {
        let userID = loginManager.userID ?? ""
        loadKikurageStateWithUserUseCase.invoke(uid: userID) { [weak self] result in
            switch result {
            case .success(let res):
                self?.delegate?.appPresenterDidSuccessGetKikurageInfo(self, kikurageInfo: (user: res.user, state: res.state))
            case .failure:
                self?.delegate?.appPresenterDidFailedGetKikurageInfo(self, errorMessage: "") // TODO: Error descriptionを渡す. InfrastructureにError型を定義しているので、それらをMapするError型をKDRepositoryに定義してService層へ通知する
            }
        }
    }

    public func loadFacebookGroupURL() {
        appConfigRepository.getFacebookGroupURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.facebookGroupURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Facebook Group URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    public func loadTermsURL() {
        appConfigRepository.getTermsURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.termsURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Terms URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    public func loadPrivacyPolicyURL() {
        appConfigRepository.getPrivacyPolicyURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.privacyPolicyURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Privacy Policy URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    public func loadLatestAppVersion() {
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
