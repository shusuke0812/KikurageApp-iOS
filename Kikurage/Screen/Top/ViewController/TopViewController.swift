//
//  TopViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UIViewControllerNavigatable, TopAccessable {
    private let baseView = TopBaseView()

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()

        navigationItem.title = R.string.localizable.screen_top_title()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.top)
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
    func topBaseViewDidTappedTermsButton(_ topBaseView: TopBaseView) {
        let urlString = AppConfig.shared.termsURL
        presentSafariView(from: self, urlString: urlString, onError: nil)
    }

    func topBaseViewDidTappedPrivacyPolicyButton(_ topBaseView: TopBaseView) {
        let urlString = AppConfig.shared.privacyPolicyURL
        presentSafariView(from: self, urlString: urlString, onError: nil)
    }

    func topBaseViewDidTappedLoginButton(_ topBaseView: TopBaseView) {
        pushToLogin()
    }

    func topBaseViewDidTappedSignUpButton(_ topBaseView: TopBaseView) {
        pushToSignUp()
    }
}
