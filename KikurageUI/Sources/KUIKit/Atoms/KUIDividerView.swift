//
//  KUIDividerView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/29.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIDividerViewProps {
    let color: Color

    public init(color: Color = Color(uiColor: .lightGray)) {
        self.color = color
    }
}

public struct KUIDividerView: View {
    private let props: KUIDividerViewProps

    public init(props: KUIDividerViewProps = KUIDividerViewProps()) {
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
        KUIDividerView()
            .padding()
    }
}
