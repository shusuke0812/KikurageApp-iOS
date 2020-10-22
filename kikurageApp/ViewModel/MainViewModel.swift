//
//  MainViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import Firebase

protocol MainViewModelDelgate: class {
    /// きくらげの状態データ取得に成功した
    func didSuccessGetKikurageState()
    /// きくらげの状態データ取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageState(errorMessage: String)
    /// きくらげの状態データが更新された
    func didChangedKikurageState()
    /// きくらげユーザーの取得に成功した
    func didSuccessGetKikurageUser()
    /// きくらげユーザーの取得に失敗した
    func didFailedGetKikurageUser(errorMessage: String)
}

class MainViewModel {
    /// きくらげの状態リスナー
    private var kikurageStateListener: ListenerRegistration?
    /// きくらげの状態取得リポジトリ
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    /// きくらげユーザー取得リポジトリ
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    /// きくらげの状態
    internal var kikurageState: KikurageState?
    /// きくらげユーザー
    internal var kikurageUser: KikurageUser?
    /// デリゲート
    internal weak var delegate: MainViewModelDelgate?
    
    // テスト用ID（後で消す）
    let uid: String = "BFwAuLtNWTg3YKhOqYsj"
    let userId: String = "i0GrcLgkBBoLrBgGtrjp"
    
    init(kikurageStateRepository: KikurageStateRepositoryProtocol,
         kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
        self.setKikurageStateListener()
    }
    deinit {
        self.kikurageStateListener?.remove()
    }
}
// きくらげの状態データ
extension MainViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        self.kikurageStateRepository.getKikurageState(
            uid: self.uid,
            completion: { response in
                switch response {
                case .success(let kikurageState):
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.kikurageState = kikurageState
                        self?.delegate?.didSuccessGetKikurageState()
                    }
                case .failure(let error):
                    print("DEBUG: \(error)")
                    self.delegate?.didFailedGetKikurageState(errorMessage: "きくらげの状態を取得できませんでした")
                }
            })
    }
    /// きくらげの状態を監視して更新を通知する
    func setKikurageStateListener() {
        self.kikurageStateListener = Firestore.firestore().collection("kikurageStates").document(self.uid).addSnapshotListener {
            [weak self] (snapshot, error) in
            guard let snapshot: DocumentSnapshot = snapshot else {
                print("DEBUG: \(error!)")
                return
            }
            guard let snapshotData = snapshot.data() else {
                print("きくらげの状態データがありません")
                return
            }
            do {
                let kikurageState: KikurageState = try Firestore.Decoder().decode(KikurageState.self, from: snapshotData)
                self?.kikurageState = kikurageState
                self?.delegate?.didChangedKikurageState()
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        }
    }
}
// きくらげユーザー
extension MainViewModel {
    func loadKikurageUser() {
        self.kikurageUserRepository.getKikurageUser(
            uid: userId,
            completion: { responsse in
                switch responsse {
                case .success(let kikurageUser):
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.kikurageUser = kikurageUser
                        self?.delegate?.didSuccessGetKikurageUser()
                    }
                case .failure(let error):
                    print("DEBUG: \(error)")
                    self.delegate?.didFailedGetKikurageUser(errorMessage: "きくらげユーザーを取得できませんでした")
                }
            })
    }
}
