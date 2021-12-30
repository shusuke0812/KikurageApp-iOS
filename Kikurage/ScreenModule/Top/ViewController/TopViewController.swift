//
//  TopViewController.swift
//  Kikurage
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
        setDelegate()

        navigationItem.title = R.string.localizable.screen_top_title()
        adjustNavigationBarBackgroundColor()
    }
}

// MARK: - Initialized

extension TopViewController {
    private func setDelegate() {
        baseView.delegate = self
    }
}

// MARK: - TopBaseView Delegate

extension TopViewController: TopBaseViewDelegate {
    func didTappedTermsButton() {
        let urlString = AppConfig.shared.termsUrl
        transitionSafariViewController(urlString: urlString, onError: nil)
    }

    func didTappedPrivacyPolicyButton() {
        let urlString = AppConfig.shared.privacyPolicyUrl
        transitionSafariViewController(urlString: urlString, onError: nil)
    }

    func didTappedLoginButton() {
        guard let vc = R.storyboard.loginViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTappedSignUpButton() {
        guard let vc = R.storyboard.signUpViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
