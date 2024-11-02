//
//  KUICircleButton.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/2.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

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

public class KUICircleButton: UIButton {
    public var onTap: (() -> Void)?

    public init(props: KUICircleButtonProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
        setupAction()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent(props: KUICircleButtonProps) {
        backgroundColor = props.variant.backgroundColor
        setImage(props.image, for: .normal)
        contentMode = .scaleToFill
        layer.masksToBounds = true
        layer.cornerRadius = props.width / 2
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: props.width),
            heightAnchor.constraint(equalToConstant: props.width)
        ])
    }

    private func setupAction() {
        addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.onTap?()
        }, for: .touchUpInside)
    }
}
