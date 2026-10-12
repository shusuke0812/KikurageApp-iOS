//
//  KUICircleButton.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/2.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUICircleButtonProps {
    let variant: KUIButtonVariant
    let image: UIImage?
    let width: CGFloat

    public init(variant: KUIButtonVariant, image: UIImage?, width: CGFloat) {
        self.variant = variant
        self.image = image
        self.width = width
    }
}

public struct KUICircleButton: View {
    private let props: KUICircleButtonProps
    public var onTap: (() -> Void)?

    public init(props: KUICircleButtonProps, onTap: (() -> Void)? = nil) {
        self.props = props
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            if let image = props.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: props.width * 0.5, height: props.width * 0.5)
            }
        }
        .frame(width: props.width, height: props.width)
        .background(Color(uiColor: props.variant.backgroundColor))
        .foregroundColor(Color(uiColor: props.variant.titleColor))
        .clipShape(Circle())
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KUICircleButton(props: KUICircleButtonProps(
            variant: .primary,
            image: UIImage(systemName: "plus"),
            width: 60
        ))
    }
}
