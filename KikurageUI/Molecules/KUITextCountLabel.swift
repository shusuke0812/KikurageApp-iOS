//
//  KUITextCountLabel.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/3.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUITextCountLabelProps {
    let textColor: UIColor
    let maxCount: Int

    public init(textColor: UIColor = .lightGray, maxCount: Int) {
        self.textColor = textColor
        self.maxCount = maxCount
    }
}

public class KUITextCountLabel: UIView {
    private var inputTextLabel: UILabel!
    private var maxInputTextLabel: UILabel!

    public init(props: KUITextCountLabelProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateInputTextCount(_ value: Int) {
        inputTextLabel.text = "\(value)"
    }

    private func setupComponent(props: KUITextCountLabelProps) {
        inputTextLabel = UILabel()
        inputTextLabel.text = "0"
        inputTextLabel.textColor = props.textColor

        let slashLabel = UILabel()
        slashLabel.textColor = props.textColor

        maxInputTextLabel = UILabel()
        maxInputTextLabel.text = "\(props.maxCount)"
        maxInputTextLabel.textColor = props.textColor

        let stackView = UIStackView(arrangedSubviews: [
            inputTextLabel,
            slashLabel,
            maxInputTextLabel
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
