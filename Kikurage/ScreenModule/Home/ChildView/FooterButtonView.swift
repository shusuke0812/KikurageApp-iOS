//
//  FooterButtonView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/25.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol FooterButtonViewDelegate: AnyObject {
    func footerButtonViewDidTapCultivationButton()
    func footerButtonViewDidTapRecipeButton()
    func footerButtonViewDidTapCommunicationButton()
}

class FooterButtonView: UIView {
    
    static let iconSize = CGSize(width: 40, height: 40)
    static let backgroundColor = UIColor.white
    static let cornerRadius: CGFloat = .viewCornerRadius
    
    private var parentView: UIView = {
        let v = UIView()
        v.backgroundColor = backgroundColor
        v.clipsToBounds = true
        v.layer.cornerRadius = cornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private var cultivationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.fontAwesomeIcon(name: .leaf, style: .solid, textColor: Constants.Color.cultivation.rawValue, size: iconSize), for: .normal)
        btn.addTarget(self, action: #selector(onCultivation(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private var recipeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.fontAwesomeIcon(name: .utensils, style: .solid, textColor: Constants.Color.recipe.rawValue, size: iconSize), for: .normal)
        btn.addTarget(self, action: #selector(onRecipe(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private var communicationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.fontAwesomeIcon(name: .handsHelping, style: .solid, textColor: Constants.Color.communication.rawValue, size: iconSize), for: .normal)
        btn.addTarget(self, action: #selector(onCommunication(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    weak var delegate: FooterButtonViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    // MARK: - Action
    
    @objc private func onCultivation(_ sender: UIButton) {
        delegate?.footerButtonViewDidTapCultivationButton()
    }
    @objc private func onRecipe(_ sender: UIButton) {
        delegate?.footerButtonViewDidTapRecipeButton()
    }
    @objc private func onCommunication(_ sender: UIButton) {
        delegate?.footerButtonViewDidTapCommunicationButton()
    }
}

// MARK: - Initialized

extension FooterButtonView {
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