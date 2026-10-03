//
//  KUILabelWithImage.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public enum KUILabelWithImageVariant {
    case imagePositionRight
    case imagePositionLeft
}

public struct KUILabelWithImageProps {
    let variant: KUILabelWithImageVariant
    let title: String
    let iamge: UIImage?

    public init(
        variant: KUILabelWithImageVariant,
        title: String,
        iamge: UIImage? = nil
    ) {
        self.variant = variant
        self.title = title
        self.iamge = iamge
    }
}

@available(*, deprecated, renamed: "KLabelWithImage", message: "Need to change to SwiftUI")
public class KUILabelWithImage: UIView {
    private var label: UILabel!
    private var imageView: UIImageView!
    private var stackView: UIStackView!

    public init(props: KUILabelWithImageProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent(props: KUILabelWithImageProps) {
        label = UILabel()
        label.text = props.title
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false

        imageView = UIImageView()
        imageView.image = props.iamge
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if props.variant == .imagePositionRight {
            stackView = UIStackView(arrangedSubviews: [label, imageView])
        } else {
            stackView = UIStackView(arrangedSubviews: [imageView, label])
        }
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.heightAnchor.constraint(equalToConstant: 27),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

public enum KLabelWithImageVariant {
    case imagePositionRight
    case imagePositionLeft
}

public struct KLabelWithImageProps {
    let variant: KLabelWithImageVariant
    let title: String
    let image: UIImage?

    public init(
        variant: KLabelWithImageVariant,
        title: String,
        image: UIImage? = nil
    ) {
        self.variant = variant
        self.title = title
        self.image = image
    }
}

public struct KLabelWithImage: View {
    private let props: KLabelWithImageProps

    public init(props: KLabelWithImageProps) {
        self.props = props
    }

    public var body: some View {
        HStack {
            if props.variant == .imagePositionLeft {
                imageView
            }
            Text(props.title)
                .font(.system(size: 15, weight: .bold))
            if props.variant == .imagePositionRight {
                Spacer()
                imageView
            }
        }
    }

    @ViewBuilder
    private var imageView: some View {
        if let image = props.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
        }
    }
}
