//
//  KUIRoundedView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIRoundedViewProps {
    let backgroundColor: Color
    let cornerRadius: CGFloat

    public init(
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = .viewCornerRadius
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

public struct KUIRoundedView<Content: View>: View {
    private let props: KUIRoundedViewProps
    private let content: () -> Content

    public init(
        props: KUIRoundedViewProps = KUIRoundedViewProps(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.props = props
        self.content = content
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: props.cornerRadius)
            .fill(props.backgroundColor)
            .overlay(content())
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KUIRoundedView {
            Text("Content")
                .padding()
        }
        .padding()
    }
}
