//
//  CalendarViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol CalendarViewModelDelegate: class {
    /// きくらげユーザーの取得に成功した
    func didSuccessGetKikurageUser()
    /// きくらげユーザーの取得に失敗しました
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageUser(errorMessage: String)
}

class CalendarViewModel {
    /// きくらげユーザー取得リポジトリ
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    /// デリゲート
    internal weak var delegate: CalendarViewModelDelegate?
    /// きくらげユーザー
    var kikurageUser: KikurageUser?
    
    init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
    }
}
// MARK: - Firebase Firestore Method
extension CalendarViewModel {
    /// きくらげユーザーを取得する
    /// - Parameter uid: ユーザーID
    func loadKikurageUser(uid: String) {
        self.kikurageUserRepository
            .getKikurageUser(uid: uid,
                             completion: { [weak self] response in
                                switch response {
                                case .success(let kikurageUser):
                                    self?.kikurageUser = kikurageUser
                                    self?.delegate?.didSuccessGetKikurageUser()
                                case .failure(let error):
                                    print("DEBUG: \(error)")
                                    self?.delegate?.didFailedGetKikurageUser(errorMessage: "ユーザー情報の取得に失敗しました")
                                }
                             })
    }
}
