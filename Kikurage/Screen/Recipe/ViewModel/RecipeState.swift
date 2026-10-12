//
//  RecipeState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/4.
//

import Combine
import Foundation
import KDEntity

final class RecipeState: ObservableObject {
    @Published var recipes: [KikurageRecipeTuple] = []
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
}
