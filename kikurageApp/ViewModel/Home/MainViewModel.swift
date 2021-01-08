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
}

class MainViewModel {
    /// きくらげの状態リスナー
    private var kikurageStateListener: ListenerRegistration?
    /// きくらげの状態取得リポジトリ
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    /// きくらげの状態
    var kikurageState: KikurageState?
    /// きくらげの状態ID（プロダクトキー ）
    var kikuragestateId: String!
    /// きくらげユーザー
    var kikurageUser: KikurageUser?
    /// デリゲート
    internal weak var delegate: MainViewModelDelgate?
    
    init(kikurageStateRepository: KikurageStateRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.setKikurageStateListener()
    }
    deinit {
        self.kikurageStateListener?.remove()
    }
}
// MARK: - Firebase Firestore Method
extension MainViewModel {
    /// きくらげの状態を読み込む
    func loadKikurageState() {
        self.kikurageStateRepository
            .getKikurageState(productId: self.kikuragestateId,
                              completion: { response in
                                switch response {
                                case .success(let kikurageState):
                                    DispatchQueue.main.async { [weak self] in
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
        self.kikurageStateListener = Firestore.firestore().collection("kikurageStates").document(self.kikuragestateId).addSnapshotListener { [weak self] (snapshot, error) in
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
