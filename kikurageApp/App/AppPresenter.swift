//
//  AppPresenter.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/4.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol AppPresenterDelegate: AnyObject {
    /// きくらげユーザーの取得に成功した
    func didSuccessGetKikurageUser(kikurageUser: KikurageUser)
    /// きくらげユーザーの取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageUser(errorMessage: String)
}

class AppPresenter {
    /// きくらげユーザー取得リポジトリ
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: AppPresenterDelegate?

    init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Initialized
extension AppPresenter {
    /// ユーザーIDが`UserDefaults`に登録されているか確認し、ある場合はユーザーを取得する
    func checkSavedUserId() {
        guard let userId: String = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userId) else {
            self.delegate?.didFailedGetKikurageUser(errorMessage: "きくらげユーザーを取得できませんでした")
            return
        }
        self.loadKikurageUser(uid: userId)
    }
}

// MARK: - Firebase Firestore
extension AppPresenter {
    /// きくらげユーザーを取得する
    /// - Parameter uid: ユーザーID
    func loadKikurageUser(uid: String) {
        self.kikurageUserRepository.getKikurageUser(uid: uid) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.delegate?.didSuccessGetKikurageUser(kikurageUser: kikurageUser)
            case .failure(let error):
                print(error)
                self?.delegate?.didFailedGetKikurageUser(errorMessage: "きくらげユーザーを取得できませんでした")
            }
        }
    }
}
