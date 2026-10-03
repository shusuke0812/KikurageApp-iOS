//
//  KUIDividerView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/29.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUIDividerViewProps {
    let color: UIColor

    public init(color: UIColor = .lightGray) {
        self.color = color
    }
}

public class KUIDividerView: UIView {
    public init(props: KUIDividerViewProps = KUIDividerViewProps()) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent(props: KUIDividerViewProps) {
        backgroundColor = props.color
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}

public struct KDividerViewProps {
    let color: Color

    public init(color: Color = Color(uiColor: .lightGray)) {
        self.color = color
    }
}

public struct KDividerView: View {
    private let props: KDividerViewProps

    public init(props: KDividerViewProps = KDividerViewProps()) {
        self.props = props
    }

    public var body: some View {
        Rectangle()
            .fill(props.color)
            .frame(height: 0.5)
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KDividerView()
            .padding()
    }
}
