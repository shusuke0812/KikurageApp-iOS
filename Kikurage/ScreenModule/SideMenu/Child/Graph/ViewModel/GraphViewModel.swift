//
//  GraphViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol GraphViewModelDelegate: AnyObject {
    func graphViewModelDidSuccessGetKikurageStateGraph(_ graphViewModel: GraphViewModel, temperatureWeeklyDatas: [Int], humidityWeeklyDatas: [Int])
    func graphViewModelDidFailedGetKikurageStateGraph(_ graphViewModel: GraphViewModel, with errorMessage: String)
    func graphViewModelDidSuccessGetKikurageUser(_ graphViewModel: GraphViewModel, kikurageUser: KikurageUser)
    func graphViewModelDidFailedGetKikurageUser(_ graphViewModel: GraphViewModel, with errorMessage: String)
}

class GraphViewModel {
    private let kikurageStateRepository: KikurageStateRepositoryProtocol
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: GraphViewModelDelegate?

    init(kikurageStateRepository: KikurageStateRepositoryProtocol, kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageStateRepository = kikurageStateRepository
        self.kikurageUserRepository = kikurageUserRepository
    }
}

// MARK: - Data Setting

extension GraphViewModel {
    private func getTemperatureWeeklyGraphDatas(kikurageStateGraphs: [KikurageStateGraphTuple]) -> [Int] {
        guard let graphData = kikurageStateGraphs.first?.data else {
            return []
        }
        var graphDatas: [Int] = []
        graphDatas.append(graphData.mondayData?.temperature ?? 0)
        graphDatas.append(graphData.tuesdayData?.temperature ?? 0)
        graphDatas.append(graphData.wednesdayData?.temperature ?? 0)
        graphDatas.append(graphData.thursdayData?.temperature ?? 0)
        graphDatas.append(graphData.fridayData?.temperature ?? 0)
        graphDatas.append(graphData.saturdayData?.temperature ?? 0)
        graphDatas.append(graphData.sundayData?.temperature ?? 0)

        return graphDatas
    }

    private func getHumidityWeeklyGraphDatas(kikurageStateGraphs: [KikurageStateGraphTuple]) -> [Int] {
        guard let graphData = kikurageStateGraphs.first?.data else {
            return []
        }
        var graphDatas: [Int] = []
        graphDatas.append(graphData.mondayData?.humidity ?? 0)
        graphDatas.append(graphData.tuesdayData?.humidity ?? 0)
        graphDatas.append(graphData.wednesdayData?.humidity ?? 0)
        graphDatas.append(graphData.thursdayData?.humidity ?? 0)
        graphDatas.append(graphData.fridayData?.humidity ?? 0)
        graphDatas.append(graphData.saturdayData?.humidity ?? 0)
        graphDatas.append(graphData.sundayData?.humidity ?? 0)

        return graphDatas
    }
}

// MARK: - Firebase Firestore

extension GraphViewModel {
    func loadKikurageStateGraph(productID: String) {
        let request = KiikurageStateGraphRequest(productID: productID)
        kikurageStateRepository.getKikurageStateGraph(request: request) { [weak self] response in
            guard let self else {
                assertionFailure()
                return
            }
            switch response {
            case .success(let graphs):
                let temperatureDatas = self.getTemperatureWeeklyGraphDatas(kikurageStateGraphs: graphs)
                let humidityDatas = self.getHumidityWeeklyGraphDatas(kikurageStateGraphs: graphs)
                self.delegate?.graphViewModelDidSuccessGetKikurageStateGraph(self, temperatureWeeklyDatas: temperatureDatas, humidityWeeklyDatas: humidityDatas)
            case .failure(let error):
                self.delegate?.graphViewModelDidFailedGetKikurageStateGraph(self, with: error.description())
            }
        }
    }

    func loadKikurageUser(uid: String) {
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.delegate?.graphViewModelDidSuccessGetKikurageUser(self!, kikurageUser: kikurageUser)
            case .failure(let error):
                self?.delegate?.graphViewModelDidFailedGetKikurageUser(self!, with: error.description())
            }
        }
    }
}
