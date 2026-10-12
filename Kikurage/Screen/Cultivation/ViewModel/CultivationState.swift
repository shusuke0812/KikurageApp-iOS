//
//  CultivationState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/4.
//

import Combine
import Foundation
import KDEntity

final class CultivationState: ObservableObject {
    @Published var cultivations: [KikurageCultivationTuple] = []
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
}
