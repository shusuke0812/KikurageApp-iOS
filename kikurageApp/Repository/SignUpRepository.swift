//
//  SignUpRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/8.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol SignUpRepositoryProtocol {
    /// 新規ユーザー登録を行う
    /// - Parameters:
    ///   - registerInfo:（メールアドレス, パスワード）
    ///   - completion: ユーザー登録成功、失敗のハンドル
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<User, Error>) -> Void)
}

class SignUpRepository: SignUpRepositoryProtocol {
}

// MARK: - UserDefaults
extension SignUpRepository {
    /* MEMO:
       - UserDefaultsへの`User`情報を登録する処理はどのクラスに書くべきか -> UIロジックに使うわけではないのでViewModelではなく、Repositoryクラスに一旦追記
       - 登録エラーのハンドリングをUIに表示すべきか and エラーであった場合の処理をどうすべきか
    */
    /// ユーザー情報を`UserDefaults`へ保存する
    /// - Parameter user: Firebase Auth ユーザー
    private func setUserInUserDefaults(user: User) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaultsKey.firebaseUser)
            print("DEBUG: ユーザー情報を`UserDefaults`に保存しました")
        } catch {
            print("DEBUG: ユーザー情報のを`UserDefaults`に保存できませんでした -> " + error.localizedDescription)
        }
    }
}

// MARK: - Firebase Authentication
extension SignUpRepository {
    func registerUser(registerInfo: (email: String, password: String), completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: registerInfo.email, password: registerInfo.password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            user.sendEmailVerification { [weak self] error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                self?.setUserInUserDefaults(user: user)
                completion(.success(user))
            }
        }
    }
}
