//
//  FooterButtonView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/25.
//  Copyright © 2021 shusuke. All rights reserved.
//

import FontAwesome_swift
import UIKit

class KUIFooterButtonView: UIView {
    static let iconSize = CGSize(width: 40, height: 40)
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = .viewCornerRadius

    private var parentView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private(set) var cultivationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.fontAwesomeIcon(name: .leaf, style: .solid, textColor: Constants.Color.cultivation.rawValue, size: iconSize), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private(set) var recipeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.fontAwesomeIcon(name: .utensils, style: .solid, textColor: Constants.Color.recipe.rawValue, size: iconSize), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private(set) var communicationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.fontAwesomeIcon(name: .handsHelping, style: .solid, textColor: Constants.Color.communication.rawValue, size: iconSize), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
}

// MARK: - Initialized

extension KUIFooterButtonView {
    private func initUI() {
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
