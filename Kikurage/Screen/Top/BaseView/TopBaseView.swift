//
//  TopBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

protocol TopBaseViewDelegate: AnyObject {
    func topBaseViewDidTappedTermsButton(_ topBaseView: TopBaseView)
    func topBaseViewDidTappedPrivacyPolicyButton(_ topBaseView: TopBaseView)
    func topBaseViewDidTappedLoginButton(_ topBaseView: TopBaseView)
    func topBaseViewDidTappedSignUpButton(_ topBaseView: TopBaseView)
}

class TopBaseView: UIView {
    private let topImageView = UIImageView()
    private var loginButton: KUIButton!
    private var signUpButton: KUIButton!
    private var termsButton: KUIUnderlinedTextButton!
    private var privacyButton: KUIUnderlinedTextButton!
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
        loginButton = KUIButton(props: KUIButtonProps(
            title: R.string.localizable.screen_top_login_btn_name(),
            backgroundColor: R.color.subColor(),
            accessibilityIdentifier: AccessibilityIdentifierManager.topLoginButton(),
            titleColor: .white,
            fontWeight: .bold
        ))

        // SignUp button
        signUpButton = KUIButton(props: KUIButtonProps(
            title: R.string.localizable.screen_top_signup_btn_name(),
            fontWeight: .bold
        ))

        // Terms and privacy buttons
        termsButton = KUIUnderlinedTextButton(props: KUIUnderlinedTextButtonProps(
            title: R.string.localizable.screen_top_app_term()
        ))
        privacyButton = KUIUnderlinedTextButton(props: KUIUnderlinedTextButtonProps(
            title: R.string.localizable.screen_top_app_privacy()
        ))

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

            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 35),
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
        loginButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedLoginButton(self)
        }

        signUpButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedSignUpButton(self)
        }

        termsButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedTermsButton(self)
        }

        privacyButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.topBaseViewDidTappedPrivacyPolicyButton(self)
        }
    }
}
