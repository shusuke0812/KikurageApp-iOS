//
//  TopBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol TopBaseViewDelegate: AnyObject {
    func topBaseViewDidTappedTermsButton(_ topBaseView: TopBaseView)
    func topBaseViewDidTappedPrivacyPolicyButton(_ topBaseView: TopBaseView)
    func topBaseViewDidTappedLoginButton(_ topBaseView: TopBaseView)
    func topBaseViewDidTappedSignUpButton(_ topBaseView: TopBaseView)
}

class TopBaseView: UIView {
    private let topImageView = UIImageView()
    private let loginButton = UIButton()
    private let signUpButton = UIButton()
    private let termsButton = UIButton(type: .system)
    private let privacyButton = UIButton(type: .system)
    private let copyrightLabel = UILabel()

    weak var delegate: TopBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupComponent()
        setupButtonAction()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        // Top image
        topImageView.image = R.image.kikurageDevice()
        topImageView.clipsToBounds = true
        topImageView.layer.cornerRadius = .viewCornerRadius
        topImageView.contentMode = .scaleAspectFill
        topImageView.translatesAutoresizingMaskIntoConstraints = false

        // Login button
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = .buttonCornerRadius
        loginButton.setTitle(R.string.localizable.screen_top_login_btn_name(), for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        loginButton.backgroundColor = R.color.subColor()
        loginButton.accessibilityIdentifier = AccessibilityIdentifierManager.topLoginButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        // SignUp button
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = .buttonCornerRadius
        signUpButton.setTitle(R.string.localizable.screen_top_signup_btn_name(), for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        signUpButton.backgroundColor = .white
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        // Terms and privacy buttons
        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.black]
        let termsButtonAttributedString = NSAttributedString(string: R.string.localizable.screen_top_app_term(), attributes: attributes)
        let privacyButtonAttributedString = NSAttributedString(string: R.string.localizable.screen_top_app_privacy(), attributes: attributes)
        termsButton.setAttributedTitle(termsButtonAttributedString, for: .normal)
        privacyButton.setAttributedTitle(privacyButtonAttributedString, for: .normal)

        termsButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        termsButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        privacyButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        privacyButton.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let termsPrivacystackView = UIStackView(arrangedSubviews: [termsButton, privacyButton])
        termsPrivacystackView.axis = .horizontal
        termsPrivacystackView.distribution = .fill
        termsPrivacystackView.alignment = .fill
        termsPrivacystackView.spacing = 20
        termsPrivacystackView.translatesAutoresizingMaskIntoConstraints = false

        // Copryright label
        copyrightLabel.textAlignment = .center
        copyrightLabel.text = R.string.localizable.screen_top_copy_right()
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(topImageView)
        addSubview(loginButton)
        addSubview(signUpButton)
        addSubview(termsPrivacystackView)
        addSubview(copyrightLabel)

        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            topImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            topImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            topImageView.heightAnchor.constraint(equalTo: topImageView.widthAnchor, multiplier: .imageViewRatio),

            loginButton.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 45),

            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            signUpButton.heightAnchor.constraint(equalToConstant: 45),

            termsPrivacystackView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 30),
            termsPrivacystackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            termsPrivacystackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),

            copyrightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            copyrightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            copyrightLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }

    // MARK: - Action

    private func setupButtonAction() {
        loginButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedLoginButton(self)
        }, for: .touchUpInside)

        signUpButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedSignUpButton(self)
        }, for: .touchUpInside)

        termsButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedTermsButton(self)
        }, for: .touchUpInside)

        privacyButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedPrivacyPolicyButton(self)
        }, for: .touchUpInside)
    }
}
