//
//  KUIUnderlinedTextButton.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/6.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUIUnderlinedTextButtonProps {
    let title: String

    public init(title: String) {
        self.title = title
    }
}

@available(*, deprecated, renamed: "KUnderlinedTextButton", message: "Need to change to SiwftUI")
public class KUIUnderlinedTextButton: UIButton {
    public var onTap: (() -> Void)?

    public init(props: KUIUnderlinedTextButtonProps) {
        super.init(frame: .zero)
        setup(props: props)
        setupButtonAction()
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setup(props: KUIUnderlinedTextButtonProps) {
        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.black]
        let attributedString = NSAttributedString(string: props.title, attributes: attributes)
        setAttributedTitle(attributedString, for: .normal)

        titleLabel?.font = .systemFont(ofSize: 15)
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

public struct KUnderlinedTextButtonProps {
    let title: String
    let color: Color
    let fontWeiht: Font.Weight

    public init(
        title: String,
        color: Color = .blue,
        fontWeiht: Font.Weight = .thin
    ) {
        self.title = title
        self.color = color
        self.fontWeiht = fontWeiht
    }
}

public struct KUnderlinedTextButton: View {
    private let props: KUnderlinedTextButtonProps

    public var onTap: (() -> Void)?

    public init(props: KUnderlinedTextButtonProps, onTap: (() -> Void)? = nil) {
        self.props = props
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: {
            onTap?()
        }, label: {
            Text(props.title)
                .foregroundColor(props.color)
                .font(.system(size: 15))
                .fontWeight(props.fontWeiht)
                .underline()
        })
    }
}
