//
//  TopBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol TopBaseViewDelegate: AnyObject {
    func didTappedTermsButton()
    func didTappedPrivacyPolicyButton()
    func didTappedLoginButton()
    func didTappedSignUpButton()
}

class TopBaseView: UIView {
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var copyrightLabel: UILabel!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!

    weak var delegate: TopBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action
    @IBAction private func didTappedTermsButton(_ sender: Any) {
        delegate?.didTappedTermsButton()
    }
    @IBAction private func didTappedPrivacyPolicyButton(_ sender: Any) {
        delegate?.didTappedPrivacyPolicyButton()
    }
    @IBAction private func didTappedLoginButton(_ sender: Any) {
        delegate?.didTappedLoginButton()
    }
    @IBAction private func didTappedSignUpButton(_ sender: Any) {
        delegate?.didTappedSignUpButton()
    }
}

// MARK: - Initialized
extension TopBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground
        
        topImageView.image = R.image.kikurageDevice()
        topImageView.clipsToBounds = true
        topImageView.layer.cornerRadius = .viewCornerRadius

        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = .buttonCornerRadius
        signUpButton.setTitle(R.string.localizable.screen_top_signup_btn_name(), for: .normal)

        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = .buttonCornerRadius
        loginButton.setTitle(R.string.localizable.screen_top_login_btn_name(), for: .normal)

        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.black]
        let termsButtonAttributedString = NSAttributedString(string: R.string.localizable.screen_top_app_term(), attributes: attributes)
        let privacyButtonAttributedString = NSAttributedString(string: R.string.localizable.screen_top_app_privacy(), attributes: attributes)
        termsButton.setAttributedTitle(termsButtonAttributedString, for: .normal)
        privacyButton.setAttributedTitle(privacyButtonAttributedString, for: .normal)

        copyrightLabel.text = R.string.localizable.screen_top_copy_right()
    }
}
