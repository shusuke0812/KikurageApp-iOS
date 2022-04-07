//
//  NavigationProtocol+Top.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/14.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol TopAccessable: PushNavigationProtocol, SafariViewNavigationProtocol {
    func pushToLogin()
    func pushToSignUp()
    func presentToSafariView(from vc: UIViewController, urlString: String?, onError: (() -> Void)?)
}

extension TopAccessable {
    // MARK: - Push

    func pushToLogin() {
        guard let vc = R.storyboard.loginViewController.instantiateInitialViewController() else { return }
        push(to: vc)
    }

    func pushToSignUp() {
        guard let vc = R.storyboard.signUpViewController.instantiateInitialViewController() else { return }
        push(to: vc)
    }

    // MARK: - SafariView

    func presentToSafariView(from vc: UIViewController, urlString: String?, onError: (() -> Void)?) {
        presentSafariView(from: vc, urlString: urlString, onError: onError)
    }
}
