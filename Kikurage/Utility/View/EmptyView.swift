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
        Text(type.title)
            .font(.headline)
            .bold()
            .foregroundColor(.gray)
    }
}

// MARK: - Type

enum EmptyType {
    case notFoundCultivation
    case notFoundRecipe

    var title: String {
        switch self {
        case .notFoundRecipe:
            return R.string.localizable.screen_recipe_no_recipe()
        case .notFoundCultivation:
            return R.string.localizable.screen_cultivation_no_cultivation()
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(type: .notFoundRecipe)
    }
}
