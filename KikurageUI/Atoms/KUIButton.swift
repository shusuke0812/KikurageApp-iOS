//
//  KUIButton.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/5.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIButtonProps {
    let title: String
    let backgroundColor: UIColor?
    let accessibilityIdentifier: String?
    let titleColor: UIColor
    let fontSize: CGFloat
    let fontWeight: UIFont.Weight

    public init(
        title: String,
        backgroundColor: UIColor? = .white,
        accessibilityIdentifier: String? = nil,
        titleColor: UIColor = .label,
        fontSize: CGFloat = 17.0,
        fontWeight: UIFont.Weight = .regular
    ) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

public class KUIButton: UIButton {
    public var onTap: (() -> Void)?

    public init(props: KUIButtonProps) {
        super.init(frame: .zero)
        setup(props: props)
        setupButtonAction()
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setup(props: KUIButtonProps) {
        layer.masksToBounds = true
        layer.cornerRadius = 5
        setTitle(props.title, for: .normal)
        setTitleColor(props.titleColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: props.fontSize, weight: props.fontWeight)
        backgroundColor = props.backgroundColor
        accessibilityIdentifier = props.accessibilityIdentifier
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupButtonAction() {
        addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.onTap?()
        }, for: .touchUpInside)
    }
}
