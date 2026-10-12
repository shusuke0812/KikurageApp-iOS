//
//  KUILabelWithImage.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public enum KUILabelWithImageVariant {
    case imagePositionRight
    case imagePositionLeft
}

public struct KUILabelWithImageProps {
    let variant: KUILabelWithImageVariant
    let title: String
    let image: UIImage?

    public init(
        variant: KUILabelWithImageVariant,
        title: String,
        image: UIImage? = nil
    ) {
        self.variant = variant
        self.title = title
        self.image = image
    }
}

public struct KUILabelWithImage: View {
    private let props: KUILabelWithImageProps

    public init(props: KUILabelWithImageProps) {
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

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        VStack(spacing: 20) {
            KUILabelWithImage(props: KUILabelWithImageProps(
                variant: .imagePositionRight,
                title: "画像が右",
                image: UIImage(systemName: "star.fill")
            ))
            KUILabelWithImage(props: KUILabelWithImageProps(
                variant: .imagePositionLeft,
                title: "画像が左",
                image: UIImage(systemName: "star.fill")
            ))
        }
        .padding()
    }
}
