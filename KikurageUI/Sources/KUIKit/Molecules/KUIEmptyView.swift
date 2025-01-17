//
//  KUIEmptyView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2025/1/17.
//

import SwiftUI

public struct KUIEmptyView: View {
    public let type: EmptyType

    public init(type: EmptyType) {
        self.type = type
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            if let image = type.icon.image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                    .frame(width: type.icon.frameWidth, height: type.icon.frameHeight)
            }
            Text(type.title)
                .font(.headline)
                .bold()
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

public enum EmptyType {
    case notFoundCultivation
    case notFoundRecipe
    case notFoundTweets

    public var title: String {
        switch self {
        case .notFoundRecipe:
            return R.string.localizable.screen_recipe_no_recipe()
        case .notFoundCultivation:
            return R.string.localizable.screen_cultivation_no_cultivation()
        case .notFoundTweets:
            return R.string.localizable.side_menu_dictionary_twitter_no_tweets()
        }
    }

    public var icon: (image: UIImage?, frameWidth: CGFloat, frameHeight: CGFloat) {
        switch self {
        case .notFoundRecipe:
            return (image: R.image.hakase(), frameWidth: 49, frameHeight: 32)
        case .notFoundCultivation:
            return (image: R.image.hakase(), frameWidth: 49, frameHeight: 32)
        case .notFoundTweets:
            return (image: R.image.hakase(), frameWidth: 49, frameHeight: 32)
        }
    }
}

#Preview {
    KUIEmptyView(type: .notFoundRecipe)
}
