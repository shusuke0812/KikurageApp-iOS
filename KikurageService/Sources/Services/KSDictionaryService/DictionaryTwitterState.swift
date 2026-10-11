//
//  DictionaryTwitterState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

@_exported import KDEntity

public final class DictionaryTwitterState: ObservableObject {
    @Published public var tweets: [Tweet.Status] = []
    @Published public var isLoading: Bool = false
    @Published public var hasError: Bool = false
    @Published public var errorMessage: String = ""

    public init() {}
}
