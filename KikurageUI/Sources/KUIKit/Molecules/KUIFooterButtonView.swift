//
//  KUIFooterButtonView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2021/12/25.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

public class KUIFooterButtonView: UIView {
    private let buttonWidth: CGFloat = 30
    private let cornerRadius: CGFloat = .viewCornerRadius

    private var parentView: UIView!
    public var cultivationButton: UIButton!
    public var recipeButton: UIButton!
    public var communicationButton: UIButton!

    public init() {
        super.init(frame: .zero)
        setupComponent()
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        parentView = UIView()
        parentView.backgroundColor = .white
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = cornerRadius
        parentView.translatesAutoresizingMaskIntoConstraints = false

        let cultivationImage = UIImage(
            systemName: "leaf.fill",
            withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: buttonWidth))
        )?.withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
        cultivationButton = UIButton()
        cultivationButton.setImage(cultivationImage, for: .normal)
        cultivationButton.tintColor = .systemBlue
        cultivationButton.translatesAutoresizingMaskIntoConstraints = false

        let recipeImage = UIImage(
            systemName: "fork.knife",
            withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: buttonWidth))
        )?.withTintColor(.systemOrange, renderingMode: .alwaysTemplate)
        recipeButton = UIButton()
        recipeButton.setImage(recipeImage, for: .normal)
        recipeButton.tintColor = .systemOrange
        recipeButton.translatesAutoresizingMaskIntoConstraints = false

        let communicationImage = UIImage(
            systemName: "person.2.fill",
            withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: buttonWidth))
        )?.withTintColor(.systemGreen, renderingMode: .alwaysTemplate)
        communicationButton = UIButton()
        communicationButton.setImage(communicationImage, for: .normal)
        communicationButton.tintColor = .systemGreen
        communicationButton.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(cultivationButton)
        stackView.addArrangedSubview(recipeButton)
        stackView.addArrangedSubview(communicationButton)

        parentView.addSubview(stackView)
        addSubview(parentView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -5),

            parentView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            parentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            parentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            parentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
