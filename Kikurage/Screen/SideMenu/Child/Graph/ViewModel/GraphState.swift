//
//  GraphState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

final class GraphState: ObservableObject {
    @Published var temperatureGraphDatas: [Int] = []
    @Published var humidityGraphDatas: [Int] = []
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
}
