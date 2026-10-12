//
//  GraphViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDLoginManager
import KDRepository

protocol GraphViewModelDelegate: AnyObject {
    func graphViewModelDidSuccessGetKikurageStateGraph(_ graphViewModel: GraphViewModel)
    func graphViewModelDidFailedGetKikurageStateGraph(_ graphViewModel: GraphViewModel, with errorMessage: String)
    func graphViewModelDidSuccessGetKikurageUser(_ graphViewModel: GraphViewModel)
    func graphViewModelDidFailedGetKikurageUser(_ graphViewModel: GraphViewModel, with errorMessage: String)
}

class GraphViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager

    weak var delegate: GraphViewModelDelegate?
    let state = GraphState()
    /// きくらげの１週間データ
    private var kikurageStateGraph: [KikurageStateGraphTuple] = []
    private var kikurageUser: KikurageUser?

    init(
        kikurageStateRepository: KikurageStateRepositoryProtocol = KikurageStateRepository(),
        kikurageUserRepository: KikurageUserRepositoryProtocol = KikurageUserRepository()
    ) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
        loginManager = LoginManager()
    }
}

// MARK: - Data Setting

extension GraphViewModel {
    private func setTemperatureGraphData() {
        guard let graphData = kikurageStateGraph.first?.data else {
            return
        }
        state.temperatureGraphDatas = [
            graphData.mondayData?.temperature ?? 0,
            graphData.tuesdayData?.temperature ?? 0,
            graphData.wednesdayData?.temperature ?? 0,
            graphData.thursdayData?.temperature ?? 0,
            graphData.fridayData?.temperature ?? 0,
            graphData.saturdayData?.temperature ?? 0,
            graphData.sundayData?.temperature ?? 0
        ]
    }

    private func setHumidityGraphData() {
        guard let graphData = kikurageStateGraph.first?.data else {
            return
        }
        state.humidityGraphDatas = [
            graphData.mondayData?.humidity ?? 0,
            graphData.tuesdayData?.humidity ?? 0,
            graphData.wednesdayData?.humidity ?? 0,
            graphData.thursdayData?.humidity ?? 0,
            graphData.fridayData?.humidity ?? 0,
            graphData.saturdayData?.humidity ?? 0,
            graphData.sundayData?.humidity ?? 0
        ]
    }
}

// MARK: - Firebase Firestore

extension GraphViewModel {
    /// きくらげステートのグラフデータを読み込む
    /// - Parameter productId: プロダクトキー
    func loadKikurageStateGraph() {
        guard let productKey = kikurageUser?.productKey else {
            return
        }
        let request = KiikurageStateGraphRequest(productID: productKey)
        kikurageStateRepository.getKikurageStateGraph(request: request) { [weak self] response in
            switch response {
            case .success(let graphs):
                self?.kikurageStateGraph = graphs
                self?.setTemperatureGraphData()
                self?.setHumidityGraphData()
                self?.delegate?.graphViewModelDidSuccessGetKikurageStateGraph(self!)
            case .failure(let error):
                self?.delegate?.graphViewModelDidFailedGetKikurageStateGraph(self!, with: error.description())
            }
        }
    }

    func loadKikurageUser() {
        guard let uid = loginManager.userID else {
            delegate?.graphViewModelDidFailedGetKikurageUser(self, with: "not found user id") // TODO: error.description()
            return
        }
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.delegate?.graphViewModelDidSuccessGetKikurageUser(self!)
            case .failure(let error):
                self?.delegate?.graphViewModelDidFailedGetKikurageUser(self!, with: error.description())
            }
        }
    }
}
