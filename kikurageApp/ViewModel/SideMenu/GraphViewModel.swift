//
//  GraphViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol GraphViewModelDelegate: class {
    /// きくらげの状態グラフデータの取得に成功した
    func didSuccessGetKikurageStateGraph()
    /// きくらげの状態グラフデータの取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageStateGraph(errorMessage: String)
    /// きくらげユーザーの取得に成功した
    func didSuccessGetKikurageUser()
    /// きくらげユーザーの取得に失敗した
    /// - Parameter errorMessage: エラーメッセージ
    func didFailedGetKikurageUser(errorMessage: String)
}

class GraphViewModel {
    /// きくらげの状態取得リポジトリ
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    /// きくらげユーザー取得リポジトリ
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    /// デリゲート
    internal weak var delegate: GraphViewModelDelegate?
    /// きくらげの１週間データ
    var kikurageStateGraph: [(graph: KikurageStateGraph, documentId: String)] = []
    /// きくらげユーザー
    var kikurageUser: KikurageUser?
    
    init(kikurageStateRepository: KikurageStateRepositoryProtocol,
         kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }
}
// MARK: - Firebase Firestore Method
extension GraphViewModel {
    /// きくらげステートのグラフデータを読み込む
    /// - Parameter productId: プロダクトキー
    func loadKikurageStateGraph(productId: String) {
        self.kikurageStateRepository
            .getKikurageStateGraph(productId: productId,
                                   completion: { [weak self] response in
                                    switch response {
                                    case .success(let graphs):
                                        self?.kikurageStateGraph = graphs
                                        self?.delegate?.didSuccessGetKikurageStateGraph()
                                    case .failure(let error):
                                        self?.delegate?.didFailedGetKikurageStateGraph(errorMessage: "\(error)")
                                    }
                                   })
    }
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
