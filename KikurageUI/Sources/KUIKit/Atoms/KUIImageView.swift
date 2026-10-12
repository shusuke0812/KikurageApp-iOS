//
//  KUIImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIImageProps {
    let image: UIImage?

    public init(image: UIImage?) {
        self.image = image
    }
}

public struct KUIImageView: View {
    private let props: KUIImageProps

    public init(props: KUIImageProps) {
        self.props = props
    }

    public var body: some View {
        if let image = props.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(.viewCornerRadius)
                .clipped()
        } else {
            // TODO: Not found image
        }
    }
}
