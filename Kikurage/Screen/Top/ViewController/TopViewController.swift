//
//  TopViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KAAnalytics
import KSAppService
import UIKit

class TopViewController: UIViewController, UIViewControllerNavigatable, TopAccessable {
    private var baseView: TopBaseView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        baseView = TopBaseView(delegate: self)
        addBaseView(baseView: baseView)

        navigationItem.title = R.string.localizable.screen_top_title()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.top)
    }
}

// MARK: - TopBaseView Delegate

extension TopViewController: TopBaseViewDelegate {
    func topBaseViewDidTappedTermsButton() {
        let urlString = AppConfig.shared.termsURLString
        presentSafariView(urlString: urlString, onError: nil)
    }

    func topBaseViewDidTappedPrivacyPolicyButton() {
        let urlString = AppConfig.shared.privacyPolicyURLString
        presentSafariView(urlString: urlString, onError: nil)
    }

    func topBaseViewDidTappedLoginButton() {
        pushToLogin()
    }

    func topBaseViewDidTappedSignUpButton() {
        pushToSignUp()
    }
}
