//
//  DictionaryTwitterState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation
import KDEntity

final class DictionaryTwitterState: ObservableObject {
    @Published var tweets: [Tweet.Status] = []
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
}
