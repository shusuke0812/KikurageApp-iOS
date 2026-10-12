//
//  PostCultivationState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/4.
//

import Combine
import Foundation
import UIKit

enum PostCultivationAlert: Identifiable {
    case validationFailed
    case confirmPost
    case postFailed(message: String)
    case postSucceeded

    var id: String {
        switch self {
        case .validationFailed:
            return "validationFailed"
        case .confirmPost:
            return "confirmPost"
        case .postFailed(let message):
            return "postFailed-\(message)"
        case .postSucceeded:
            return "postSucceeded"
        }
    }
}

final class PostCultivationState: ObservableObject {
    @Published var selectedImages: [UIImage?]
    @Published var memo: String = ""
    @Published var date: Date = Date()
    @Published var isPosting: Bool = false
    @Published var alert: PostCultivationAlert?

    init(maxImageCount: Int) {
        selectedImages = Array(repeating: nil, count: maxImageCount)
    }
}
