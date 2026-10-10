//
//  PostRecipeState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/4.
//

import Combine
import Foundation
import UIKit

public enum PostRecipeAlert: Identifiable {
    case confirmPost
    case postFailed(message: String)
    case postSucceeded

    public var id: String {
        switch self {
        case .confirmPost:
            return "confirmPost"
        case .postFailed(let message):
            return "postFailed-\(message)"
        case .postSucceeded:
            return "postSucceeded"
        }
    }
}

public final class PostRecipeState: ObservableObject {
    @Published public var selectedImages: [UIImage?]
    @Published public var name: String = ""
    @Published public var memo: String = ""
    @Published public var date: Date = Date()
    @Published public var isPosting: Bool = false
    @Published public var alert: PostRecipeAlert?

    public init(maxImageCount: Int) {
        selectedImages = Array(repeating: nil, count: maxImageCount)
    }
}
