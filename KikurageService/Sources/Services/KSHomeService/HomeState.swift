//
//  HomeState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/4/5.
//

import Combine
import Foundation
import UIKit

public final class HomeState: ObservableObject {
    @Published public var kikurageName: String = "-"
    @Published public var statusMessage: String = "-"
    @Published public var stateImages: [UIImage] = []
    @Published public var temperature: Int = 0
    @Published public var humidity: Int = 0
    @Published public var advice: String = "-"
    @Published public var nowTimeString: String = "-"
    @Published public var isAnimating: Bool = false
    @Published public var hasStateError: Bool = false

    public init() {}
}
