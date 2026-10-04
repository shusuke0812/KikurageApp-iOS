//
//  KUICircleImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUICircleImageViewProps {
    let image: UIImage?
    let width: CGFloat

    public init(image: UIImage?, width: CGFloat) {
        self.image = image
        self.width = width
    }
}

public class KUICircleImageView: UIImageView {
    public init(props: KUICircleImageViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent(props: KUICircleImageViewProps) {
        contentMode = .scaleAspectFit
        clipsToBounds = true
        layer.cornerRadius = props.width / 2
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        image = props.image
    }
}

public struct KCircleImageViewProps {
    let image: UIImage?
    let width: CGFloat

    public init(image: UIImage?, width: CGFloat) {
        self.image = image
        self.width = width
    }
}

public struct KCircleImageView: View {
    private let props: KCircleImageViewProps

    public init(props: KCircleImageViewProps) {
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
        KCircleImageView(props: KCircleImageViewProps(
            image: UIImage(systemName: "person.circle.fill"),
            width: 50
        ))
    }
}
