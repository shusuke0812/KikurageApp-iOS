//
//  EmptyView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/8/27.
//  Copyright © 2022 shusuke. All rights reserved.
//

import SwiftUI

struct EmptyView: View {
    let type: EmptyType

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            Image(type.iconString)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.gray)
                .frame(width: 49, height: 32)
            Text(type.title)
                .font(.headline)
                .bold()
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

// MARK: - Type

enum EmptyType {
    case notFoundCultivation
    case notFoundRecipe
    case notFoundTweets

    var title: String {
        switch self {
        case .notFoundRecipe:
            return R.string.localizable.screen_recipe_no_recipe()
        case .notFoundCultivation:
            return R.string.localizable.screen_cultivation_no_cultivation()
        case .notFoundTweets:
            return R.string.localizable.side_menu_dictionary_twitter_no_tweets()
        }
    }

    var iconString: String {
        switch self {
        case .notFoundRecipe:
            return "hakase"
        case .notFoundCultivation:
            return "hakase"
        case .notFoundTweets:
            return "hakase"
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(type: .notFoundRecipe)
    }
}
