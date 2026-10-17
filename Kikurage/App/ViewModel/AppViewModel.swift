//
//  AppViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2025/1/1.
//

import Foundation
import KALogger
import KDRepository
import KDUseCase

final class AppViewModel {
    enum Effect {
        case showHomePage(productKey: String, userId: String)
        case showTopPage
    }

    let effects: AsyncStream<Effect>
    private let effectContinuation: AsyncStream<Effect>.Continuation

    private let appConfigRepository: AppConfigRepositoryProtocol
    private let verifyLoginUseCase: VerifyLoginUseCaseProtocol

    init(
        appConfigRepository: AppConfigRepositoryProtocol = AppConfigRepository(),
        verifyLoginUseCase: VerifyLoginUseCaseProtocol = VerifyLoginUseCase()
    ) {
        self.appConfigRepository = appConfigRepository
        self.verifyLoginUseCase = verifyLoginUseCase
        (effects, effectContinuation) = AsyncStream.makeStream(of: Effect.self)
    }

    func verifyLogin() {
        verifyLoginUseCase.invoke { [weak self] result in
            switch result {
            case .success(let verifyLogin):
                switch verifyLogin {
                case let .registeredProductKey(key, userId):
                    self?.effectContinuation.yield(.showHomePage(productKey: key, userId: userId))
                case .notRegisteredProductKey, .noLogin:
                    self?.effectContinuation.yield(.showTopPage)
                }
            case .failure:
                self?.effectContinuation.yield(.showTopPage)
            }
        }
    }

    func fetchRemoteConfig() {
        loadFacebookGroupURL()
        loadTermsURL()
        loadPrivacyPolicyURL()
        loadLatestAppVersion()
    }

    private func loadFacebookGroupURL() {
        appConfigRepository.getFacebookGroupURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.facebookGroupURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Facebook Group URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    private func loadTermsURL() {
        appConfigRepository.getTermsURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.termsURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Terms URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    private func loadPrivacyPolicyURL() {
        appConfigRepository.getPrivacyPolicyURL { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.privacyPolicyURLString = urlString
            case .failure(let error):
                KLogManager.debug("Failed to get Privacy Policy URL from Remote Config : " + error.localizedDescription)
            }
        }
    }

    private func loadLatestAppVersion() {
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
