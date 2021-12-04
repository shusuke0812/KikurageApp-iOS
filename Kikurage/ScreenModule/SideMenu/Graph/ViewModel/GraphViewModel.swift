//
//  GraphViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol GraphViewModelDelegate: AnyObject {
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
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: GraphViewModelDelegate?
    /// きくらげの１週間データ
    var kikurageStateGraph: [(graph: KikurageStateGraph, documentId: String)] = []
    /// きくらげの１週間の温度データ
    var temperatureGraphDatas: [Int] = []
    /// きくらげの１週間の湿度データ
    var humidityGraphDatas: [Int] = []
    /// きくらげユーザー
    var kikurageUser: KikurageUser?

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }
}
// MARK: - Data Setting
extension GraphViewModel {
    private func setTemperatureGraphData() {
        guard let graphData = kikurageStateGraph.first?.graph else { return }
        temperatureGraphDatas.append(graphData.mondayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.tuesdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.wednesdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.thursdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.fridayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.saturdayData?.temperature ?? 0)
        temperatureGraphDatas.append(graphData.sundayData?.temperature ?? 0)
    }
    private func setHumidityGraphData() {
        guard let graphData = kikurageStateGraph.first?.graph else { return }
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
    func loadKikurageStateGraph(productId: String) {
        kikurageStateRepository.getKikurageStateGraph(productId: productId) { [weak self] response in
            switch response {
            case .success(let graphs):
                self?.kikurageStateGraph = graphs
                self?.setTemperatureGraphData()
                self?.setHumidityGraphData()
                self?.delegate?.didSuccessGetKikurageStateGraph()
            case .failure(let error):
                self?.delegate?.didFailedGetKikurageStateGraph(errorMessage: error.description())
            }
        }
    }
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
