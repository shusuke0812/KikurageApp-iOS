//
//  KUIFooterButtonView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2021/12/25.
//  Copyright © 2021 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIFooterButtonView: View {
    private let onCultivation: () -> Void
    private let onRecipe: () -> Void
    private let onCommunication: () -> Void

    public init(
        onCultivation: @escaping () -> Void,
        onRecipe: @escaping () -> Void,
        onCommunication: @escaping () -> Void
    ) {
        self.onCultivation = onCultivation
        self.onRecipe = onRecipe
        self.onCommunication = onCommunication
    }

    public var body: some View {
        KUIRoundedView {
            HStack(spacing: 5) {
                Button(action: onCultivation) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                }
                Button(action: onRecipe) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 30))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                }
                Button(action: onCommunication) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(5)
        }
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KUIFooterButtonView(
            onCultivation: {},
            onRecipe: {},
            onCommunication: {}
        )
        .frame(height: 50)
        .padding(.top, 15)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}
