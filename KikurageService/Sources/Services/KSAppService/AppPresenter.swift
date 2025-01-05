//
//  File.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/1.
//

import KDRepository
import KDEntity
import KDLoginManager
import KSFeatures
import Foundation

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
        self.loginManager = LoginManager()
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
    }
    
    public func login() {
        let userId  = loginManager.userId ?? ""
        loadKikurageStateWithUserUseCase.invoke(uid: userId) { [weak self] result in
            switch result {
            case .success(let res):
                self?.delegate?.appPresenterDidSuccessGetKikurageInfo(self, kikurageInfo: (user: res.user, state: res.state))
            case .failure:
                self?.delegate?.appPresenterDidFailedGetKikurageInfo(self, errorMessage: "") // TODO: Error descriptionを渡す. InfrastructureにError型を定義しているので、それらをMapするError型をKDRepositoryに定義してService層へ通知する
            }
        }
    }
    
    public func loadFacebookGroupURL() {
        appConfigRepository.getFacebookGroupUrl { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.facebookGroupUrlString = urlString
            case .failure:
                break
                //KLogManager.debug("Failed to get Facebook Group Url from Remote Config : " + error.localizedDescription) // TODO: Logger
            }
        }
    }

    public func loadTermsURL() {
        appConfigRepository.getTermsUrl { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.termsUrlString = urlString
            case .failure:
                break
                //KLogManager.debug("Failed to get Terms Url from Remote Config : " + error.localizedDescription) // TODO: Logger
            }
        }
    }

    public func loadPrivacyPolicyURL() {
        appConfigRepository.getPrivacyPolicyUrl { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.privacyPolicyUrlString = urlString
            case .failure:
                break
                //KLogManager.debug("Failed to get Privacy Policy Url from Remote Config : " + error.localizedDescription) // TODO: Logger
            }
        }
    }

    public func loadLatestAppVersion() {
        appConfigRepository.getLatestAppVersion { response in
            switch response {
            case .success(let appVersionString):
                let appVersion = AppVersion(versionString: appVersionString)
                AppConfig.shared.latestAppVersion = appVersion
            case .failure:
                break
                //KLogManager.debug("Failed to get iOS App Version from Remote Config : " + error.localizedDescription) // TODO: Logger
            }
        }
    }
}
