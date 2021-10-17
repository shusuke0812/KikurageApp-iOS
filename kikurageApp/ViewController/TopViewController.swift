//
//  TopViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: TopBaseView { self.view as! TopBaseView } // swiftlint:disable:this force_cast

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegate()

        self.navigationItem.title = "ようこそ！"
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
        guard let vc = R.storyboard.loginViewController.instantiateInitialViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func didTappedSignUpButton() {
        guard let vc = R.storyboard.signUpViewController.instantiateInitialViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
