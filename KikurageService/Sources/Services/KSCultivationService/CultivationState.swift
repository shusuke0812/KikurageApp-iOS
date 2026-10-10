//
//  CultivationState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/4.
//

import Combine
import Foundation

@_exported import KDEntity

public final class CultivationState: ObservableObject {
    @Published public var cultivations: [KikurageCultivationTuple] = []
    @Published public var isLoading: Bool = false
    @Published public var hasError: Bool = false

    public init() {}
}
