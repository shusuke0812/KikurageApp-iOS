//
//  KUIFooterButtonView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2021/12/25.
//  Copyright © 2021 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

@available(*, deprecated, renamed: "KFooterButtonView", message: "Need to change to SwiftUI")
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

public struct KFooterButtonView: View {
    private let onCultivation: () -> Void
    private let onRecipe: () -> Void
    private let onCommunication: () -> Void

    public init(
        onCultivation: @escaping () -> Void,
        onRecipe: @escaping () -> Void,
        onCommunication: @escaping () -> Void
    ) {
        self.onCultivation = onCultivation
        self.onRecipe = onRecipe
        self.onCommunication = onCommunication
    }

    public var body: some View {
        KRoundedView {
            HStack(spacing: 5) {
                Button(action: onCultivation) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                }
                Button(action: onRecipe) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 30))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                }
                Button(action: onCommunication) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(5)
        }
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KFooterButtonView(
            onCultivation: {},
            onRecipe: {},
            onCommunication: {}
        )
        .frame(height: 50)
        .padding(.top, 15)
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}
