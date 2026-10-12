//
//  HomeState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/4/5.
//

import Combine
import Foundation
import UIKit

final class HomeState: ObservableObject {
    @Published var kikurageName: String = "-"
    @Published var statusMessage: String = "-"
    @Published var stateImages: [UIImage] = []
    @Published var temperature: Int = 0
    @Published var humidity: Int = 0
    @Published var advice: String = "-"
    @Published var nowTimeString: String = "-"
    @Published var isAnimating: Bool = false
    @Published var hasStateError: Bool = false
}
