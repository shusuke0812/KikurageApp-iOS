//
//  KUIButton.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/5.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public enum KUIButtonVariant {
    case primary
    case secondary

    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return R.color.subColor()!
        case .secondary:
            return .white
        }
    }

    var titleColor: UIColor {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .label
        }
    }
}

public struct KUIButtonProps {
    let variant: KUIButtonVariant
    let title: String
    let accessibilityIdentifier: String?
    let fontSize: CGFloat
    let fontWeight: UIFont.Weight

    public init(
        variant: KUIButtonVariant,
        title: String,
        accessibilityIdentifier: String? = nil,
        fontSize: CGFloat = 17.0,
        fontWeight: UIFont.Weight = .bold
    ) {
        self.variant = variant
        self.title = title
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

@available(*, deprecated, renamed: "KButton", message: "Need to change to SiwftUI")
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
        setTitleColor(props.variant.titleColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: props.fontSize, weight: props.fontWeight)
        backgroundColor = props.variant.backgroundColor
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

public struct KButtonProps {
    let variant: KUIButtonVariant
    let title: String
    let accessibilityIdentifier: String
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let height: CGFloat

    public init(
        variant: KUIButtonVariant,
        title: String,
        accessibilityIdentifier: String = "",
        fontSize: CGFloat = 17.0,
        fontWeight: Font.Weight = .bold,
        height: CGFloat = 45
    ) {
        self.variant = variant
        self.title = title
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.accessibilityIdentifier = accessibilityIdentifier
        self.height = height
    }
}

public struct KButton: View {
    private let props: KButtonProps
    public var onTap: (() -> Void)?

    public init(props: KButtonProps, onTap: (() -> Void)? = nil) {
        self.props = props
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: {
            onTap?()
        }, label: {
            Text(props.title)
                .font(.system(size: props.fontSize))
                .fontWeight(props.fontWeight)
                .frame(maxWidth: .infinity, minHeight: props.height)
        })
        .foregroundColor(Color(uiColor: props.variant.titleColor))
        .background(Color(uiColor: props.variant.backgroundColor))
        .cornerRadius(5)
        .accessibilityIdentifier(props.accessibilityIdentifier)
    }
}
