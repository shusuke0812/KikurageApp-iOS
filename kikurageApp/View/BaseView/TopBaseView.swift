//
//  TopBaseView.swift
//  kikurageApp
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

    weak var delegate: TopBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    // MARK: - Action
    @IBAction private func didTappedTermsButton(_ sender: Any) {
        self.delegate?.didTappedTermsButton()
    }
    @IBAction private func didTappedPrivacyPolicyButton(_ sender: Any) {
        self.delegate?.didTappedPrivacyPolicyButton()
    }
    @IBAction private func didTappedLoginButton(_ sender: Any) {
        self.delegate?.didTappedLoginButton()
    }
    @IBAction private func didTappedSignUpButton(_ sender: Any) {
        self.delegate?.didTappedSignUpButton()
    }
}

// MARK: - Initialized
extension TopBaseView {
    private func initUI() {
        self.topImageView.image = R.image.kikurageDevice()

        self.signUpButton.layer.masksToBounds = true
        self.signUpButton.layer.cornerRadius = 5

        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 5

        self.copyrightLabel.text = "©︎ チーム きくらげ大使館"
    }
}
