//
//  CalendarViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol CalendarViewModelDelegate: AnyObject {
    /// きくらげユーザーの取得に成功した
    func didSuccessGetKikurageUser()
    /// きくらげユーザーの取得に失敗しました
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageUser(errorMessage: String)
}

class CalendarViewModel {
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: CalendarViewModelDelegate?
    /// きくらげユーザー
    var kikurageUser: KikurageUser?

    init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Firebase Firestore

extension CalendarViewModel {
    /// きくらげユーザーを取得する
    /// - Parameter uid: ユーザーID
    func loadKikurageUser(uid: String) {
        kikurageUserRepository.getKikurageUser(uid: uid) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.delegate?.didSuccessGetKikurageUser()
            case .failure(let error):
                self?.delegate?.didFailedGetKikurageUser(errorMessage: error.description())
            }
        }
    }
}
