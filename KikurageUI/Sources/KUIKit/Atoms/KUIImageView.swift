//
//  KUIImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUIImageViewProps {
    let image: UIImage?

    public init(image: UIImage?) {
        self.image = image
    }
}

@available(*, deprecated, renamed: "KImageView", message: "Need to change to SiwftUI")
public class KUIImageView: UIImageView {
    public init(props: KUIImageViewProps) {
        super.init(frame: .zero)
        setup(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setup(props: KUIImageViewProps) {
        image = props.image
        clipsToBounds = true
        layer.cornerRadius = .viewCornerRadius
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }
}

public struct KImageView: View {
    private let props: KUIImageViewProps
    
    public init(props: KUIImageViewProps) {
        self.props = props
    }

    public var body: some View {
        if let image = props.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(.viewCornerRadius)
        } else {
            // TODO: Not found image
        }
    }
}
