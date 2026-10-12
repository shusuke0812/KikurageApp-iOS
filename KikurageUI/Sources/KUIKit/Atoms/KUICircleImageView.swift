//
//  KUICircleImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUICircleImageViewProps {
    let image: UIImage?
    let width: CGFloat

    public init(image: UIImage?, width: CGFloat) {
        self.image = image
        self.width = width
    }
}

public struct KUICircleImageView: View {
    private let props: KUICircleImageViewProps

    public init(props: KUICircleImageViewProps) {
        self.props = props
    }

    public var body: some View {
        Group {
            if let image = props.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.clear
            }
        }
        .frame(width: props.width, height: props.width)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.gray, lineWidth: 0.5)
        )
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KUICircleImageView(props: KUICircleImageViewProps(
            image: UIImage(systemName: "person.circle.fill"),
            width: 50
        ))
    }
}
