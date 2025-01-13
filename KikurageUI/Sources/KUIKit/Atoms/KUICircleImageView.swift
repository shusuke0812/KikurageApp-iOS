//
//  KUICircleImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

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
