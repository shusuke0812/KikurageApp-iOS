//
//  AppPresenter.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/4.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

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

// MARK: - Firebase Firestore
extension AppPresenter {
    /// きくらげユーザーを取得する
    /// - Parameter userId: Firebase ユーザーID
    func loadKikurageUser(userId: String) {
        self.kikurageUserRepository.getKikurageUser(uid: userId) { [weak self] response in
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
