//
//  TopViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    /// BaseView
    private var baseView: TopBaseView { self.view as! TopBaseView } // swiftlint:disable:this force_cast

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Initialized
extension TopViewController {
    private func setDelegate() {
        self.baseView.delegate = self
    }
}

// MARK: - TopBaseView Delegate
extension TopViewController: TopBaseViewDelegate {
    func didTappedTermsButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.terms)
    }

    func didTappedPrivacyPolicyButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.privacyPolicy)
    }

    func didTappedLoginButton() {
    }

    func didTappedSignUpButton() {
    }
}
