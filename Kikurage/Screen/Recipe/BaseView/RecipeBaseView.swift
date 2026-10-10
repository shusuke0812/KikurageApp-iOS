//
//  RecipeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KSRecipeService
import KUIKit
import SwiftUI
import UIKit

protocol RecipeBaseViewDelegate: AnyObject {
    func recipeBaseViewDidTapAddButton()
    func recipeBaseViewDidPullToRefresh()
}

struct RecipeBaseView: View {
    @StateObject var state: RecipeState

    weak var delegate: RecipeBaseViewDelegate?

    init(delegate: RecipeBaseViewDelegate?, state: RecipeState) {
        self.delegate = delegate
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            GeometryReader { geometry in
                ScrollView {
                    if state.isLoading && state.recipes.isEmpty {
                        ProgressView()
                            .frame(height: geometry.size.height)
                    } else if state.recipes.isEmpty {
                        KUIEmptyView(type: .notFoundRecipe)
                            .frame(height: geometry.size.height)
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(state.recipes.enumerated()), id: \.offset) { _, recipe in
                                KRecipeCell(props: KRecipeCellProps(
                                    imageStoragePath: recipe.data.imageStoragePaths.first ?? "",
                                    dateString: recipe.data.cookDate,
                                    title: recipe.data.name,
                                    description: recipe.data.memo
                                ))
                                .frame(height: 160)
                            }
                        }
                    }
                }
                .refreshable {
                    delegate?.recipeBaseViewDidPullToRefresh()
                }
            }

            KCircleButton(props: KCircleButtonProps(
                variant: .primary,
                image: R.image.addMemoButton(),
                width: 60
            ), onTap: {
                delegate?.recipeBaseViewDidTapAddButton()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(20)
        }
        .alert("error", isPresented: $state.hasError) {
            Button(R.string.localizable.common_alert_ok_btn_ok(), role: .cancel) {}
        }
    }
}

#Preview {
    RecipeBaseView(delegate: nil, state: RecipeState())
}
