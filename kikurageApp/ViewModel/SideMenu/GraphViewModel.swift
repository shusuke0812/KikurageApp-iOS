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
}

class GraphViewModel {
    /// きくらげの状態取得リポジトリ
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    /// デリゲート
    internal weak var delegate: GraphViewModelDelegate?
    /// きくらげの１週間データ
    var kikurageStateGraph: [(graph: KikurageStateGraph, documentId: String)] = []
    
    init(kikurageStateRepository: KikurageStateRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
    }
}
// MARK: - Firebase Firestore Method
extension GraphViewModel {
    /// きくらげステートのグラフデータを読み込む
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
}
