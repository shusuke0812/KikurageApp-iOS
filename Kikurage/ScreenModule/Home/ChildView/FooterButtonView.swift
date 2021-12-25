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
    private var parentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        v.clipsToBounds = true
        v.layer.cornerRadius = .viewCornerRadius * 2
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
        btn.setTitle(String.fontAwesomeIcon(name: .utensils), for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(onCultivation(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private var recipeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(String.fontAwesomeIcon(name: .leaf), for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(onRecipe(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private var communicationButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(String.fontAwesomeIcon(name: .handsHelping), for: .normal)
        btn.setTitleColor(.orange, for: .normal)
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
        
        parentView.addConstraints([
            stackView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -5)
        ])
    }
}
