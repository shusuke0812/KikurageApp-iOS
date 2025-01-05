//
//  GraphViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KDLoginManager
import KDEntity
import KDRepository
import Foundation

public protocol GraphViewModelDelegate: AnyObject {
    func graphViewModelDidSuccessGetKikurageStateGraph(_ graphViewModel: GraphViewModel)
    func graphViewModelDidFailedGetKikurageStateGraph(_ graphViewModel: GraphViewModel, with errorMessage: String)
    func graphViewModelDidSuccessGetKikurageUser(_ graphViewModel: GraphViewModel)
    func graphViewModelDidFailedGetKikurageUser(_ graphViewModel: GraphViewModel, with errorMessage: String)
}

public class GraphViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager

    public weak var delegate: GraphViewModelDelegate?
    /// きくらげの１週間データ
    public var kikurageStateGraph: [KikurageStateGraphTuple] = []
    /// きくらげの１週間の温度データ
    public var temperatureGraphDatas: [Int] = []
    /// きくらげの１週間の湿度データ
    public var humidityGraphDatas: [Int] = []
    public var kikurageUser: KikurageUser?

    public init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
        self.loginManager = LoginManager()
    }
}

// MARK: - Data Setting

extension GraphViewModel {
    private func setTemperatureGraphData() {
        guard let graphData = kikurageStateGraph.first?.data else {
            return
        }
        temperatureGraphDatas.append(graphData.mondayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.tuesdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.wednesdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.thursdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.fridayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.saturdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.sundayData?.temperature ?? 0)
    }

    private func setHumidityGraphData() {
        guard let graphData = kikurageStateGraph.first?.data else {
            return
        }
        humidityGraphDatas.append(graphData.mondayData?.humidity ?? 0)
        humidityGraphDatas.append(graphData.tuesdayData?.humidity ?? 0)
        humidityGraphDatas.append(graphData.wednesdayData?.humidity ?? 0)
        humidityGraphDatas.append(graphData.thursdayData?.humidity ?? 0)
        humidityGraphDatas.append(graphData.fridayData?.humidity ?? 0)
        humidityGraphDatas.append(graphData.saturdayData?.humidity ?? 0)
        humidityGraphDatas.append(graphData.sundayData?.humidity ?? 0)
    }
}

// MARK: - Firebase Firestore

extension GraphViewModel {
    /// きくらげステートのグラフデータを読み込む
    /// - Parameter productId: プロダクトキー
    public func loadKikurageStateGraph(productID: String) {
        let request = KiikurageStateGraphRequest(productID: productID)
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

    public func loadKikurageUser() {
        guard let uid = loginManager.userId else {
            delegate?.graphViewModelDidFailedGetKikurageUser(self, with: "not found user id") //TODO: error.description()
            return
        }
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.delegate?.graphViewModelDidSuccessGetKikurageUser(self!)
            case .failure(let error):
                self?.delegate?.graphViewModelDidFailedGetKikurageUser(self!, with: "error") //TODO: error.description()
            }
        }
    }
}
