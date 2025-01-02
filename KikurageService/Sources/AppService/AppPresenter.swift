//
//  File.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/1.
//

import KDRepository
import Foundation

public protocol AppPresenterDelete: AnyObject {
    func appPresenterDidSuccessGetKikurageInfo(_ appPresenter: AppPresenter?, kikurageInfo: (user: KikurageUser?, state: KikurageState?))
    func appPresenterDidFailedGetKikurageInfo(_ appPresenter: AppPresenter?, errorMessage: String)
}

public class AppPresenter {
    private let appConfigRepository: AppConfigRepositoryProtocol
    private let loadKikurageStateWithUserUseCase: LoadKikurageStateWithUserUseCaseProtocol // TODO: KSFeaturesに移動する
    
    public  init(
        appConfigRepository: AppConfigRepositoryProtocol = AppConfigRepository()
    ) {
        self.appConfigRepository = appConfigRepository
        loadKikurageStateWithUserUseCase = LoadKikurageStateWithUserUseCase(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
    }
    
    public func login() {
        let userID = LoginHelper.shared.kikurageUserID ?? "" // TODO: KikurageDomain/InfrastructureにLocalStoreClientを定義する、KDLoginManagerに移動する
        loadKikurageStateWithUserUseCase.invoke(uid: userID) { [weak self] responses in
            switch responses {
            case .success(let res):
                self?.delegate?.appPresenterDidSuccessGetKikurageInfo(self, kikurageInfo: (user: res.user, state: res.state))
            case .failure(let error):
                self?.delegate?.appPresenterDidFailedGetKikurageInfo(self, errorMessage: error.description())
            }
        }
    }
    
    func loadFacebookGroupURL() {
        appConfigRepository.getFacebookGroupUrl { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.facebookGroupURL = urlString
            case .failure(let error):
                //KLogManager.debug("Failed to get Facebook Group Url from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadTermsURL() {
        appConfigRepository.getTermsUrl { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.termsURL = urlString
            case .failure(let error):
                //KLogManager.debug("Failed to get Terms Url from Remote Config : " + error.localizedDescription)
            }
        }
    }

    func loadPrivacyPolicyURL() {
        appConfigRepository.getPrivacyPolicyUrl { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.privacyPolicyURL = urlString
            case .failure(let error):
                //KLogManager.debug("Failed to get Privacy Policy Url from Remote Config : " + error.localizedDescription)
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
