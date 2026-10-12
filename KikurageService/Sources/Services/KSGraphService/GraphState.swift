//
//  GraphState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

public final class GraphState: ObservableObject {
    @Published public var temperatureGraphDatas: [Int] = []
    @Published public var humidityGraphDatas: [Int] = []
    @Published public var isLoading: Bool = false
    @Published public var hasError: Bool = false
    @Published public var errorMessage: String = ""

    public init() {}
}
