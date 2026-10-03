//
//  KUIRoundedView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUIRoundedViewProps {
    let backgroundColor: UIColor?

    public init(
        backgroundColor: UIColor? = .white
    ) {
        self.backgroundColor = backgroundColor
    }
}

public class KUIRoundedView: UIView {
    public init(props: KUIRoundedViewProps = KUIRoundedViewProps()) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent(props: KUIRoundedViewProps) {
        backgroundColor = props.backgroundColor
        clipsToBounds = true
        layer.cornerRadius = .viewCornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
}

public struct KRoundedViewProps {
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

public struct KRoundedView<Content: View>: View {
    private let props: KRoundedViewProps
    private let content: () -> Content

    public init(
        props: KRoundedViewProps = KRoundedViewProps(),
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
