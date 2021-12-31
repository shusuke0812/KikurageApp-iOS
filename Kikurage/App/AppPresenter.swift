//
//  AppPresenter.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/4.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol AppPresenterDelegate: AnyObject {
    /// きくらげ情報の取得に成功した
    func didSuccessGetKikurageInfo(kikurageInfo: (user: KikurageUser?, state: KikurageState?))
    /// きくらげ情報の取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageInfo(errorMessage: String)
}

class AppPresenter {
    private var kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let firebaseRemoteCofigRepository: FirebaseRemoteConfigRepositoryProtocol

    weak var delegate: AppPresenterDelegate?

    private var kikurageUser: KikurageUser?
    private var kikurageState: KikurageState?

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol, firebaseRemoteCofigRepository: FirebaseRemoteConfigRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
        self.firebaseRemoteCofigRepository = firebaseRemoteCofigRepository
    }
}

// MARK: - Setting Data

extension AppPresenter {
    private func saveDateComponents() {
        if let cultivationStartDate = kikurageUser?.cultivationStartDate {
            let components = DateHelper.getDateComponents(date: cultivationStartDate)
            AppConfig.shared.cultivationStartDateComponents = components
        }
    }
}

// MARK: - Firebase Firestore

extension AppPresenter {
    /// きくらげユーザーを取得する
    /// - Parameter userId: Firebase ユーザーID
    func loadKikurageUser(userId: String) {
        kikurageUserRepository.getKikurageUser(uid: userId) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.loadKikurageState()
                self?.saveDateComponents()
            case .failure(let error):
                self?.delegate?.didFailedGetKikurageInfo(errorMessage: error.description())
            }
        }
    }
    /// きくらげの状態を読み込む
    private func loadKikurageState() {
        let productId = (kikurageUser?.productKey)!    // swiftlint:disable:this force_unwrapping
        kikurageStateRepository.getKikurageState(productId: productId) { [weak self] response in
            switch response {
            case .success(let kikurageState):
                self?.kikurageState = kikurageState
                self?.delegate?.didSuccessGetKikurageInfo(kikurageInfo: (user: self?.kikurageUser, state: self?.kikurageState))
            case .failure(let error):
                self?.delegate?.didFailedGetKikurageInfo(errorMessage: error.description())
            }
        }
    }
}

// MARK: - Firebase RemoteConfig

extension AppPresenter {
    func loadFacebookGroupUrl() {
        firebaseRemoteCofigRepository.fetch(key: .facebookGroupUrl) { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.facebookGroupUrl = urlString
            case .failure(let error):
                Logger.verbose("Failed to get Facebook Group Url from Remote Config : " + error.localizedDescription)
            }
        }
    }
    func loadTermsUrl() {
        firebaseRemoteCofigRepository.fetch(key: .termsUrl) { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.termsUrl = urlString
            case .failure(let error):
                Logger.verbose("Failed to get Terms Url from Remote Config : " + error.localizedDescription)
            }
        }
    }
    func loadPrivacyPolicyUrl() {
        firebaseRemoteCofigRepository.fetch(key: .privacyPolicyUrl) { response in
            switch response {
            case .success(let urlString):
                AppConfig.shared.privacyPolicyUrl = urlString
            case .failure(let error):
                Logger.verbose("Failed to get Privacy Policy Url from Remote Config : " + error.localizedDescription)
            }
        }
    }
}
