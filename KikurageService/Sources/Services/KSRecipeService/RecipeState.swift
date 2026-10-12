//
//  RecipeState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/4.
//

import Combine
import Foundation

@_exported import KDEntity

public final class RecipeState: ObservableObject {
    @Published public var recipes: [KikurageRecipeTuple] = []
    @Published public var isLoading: Bool = false
    @Published public var hasError: Bool = false

    public init() {}
}
