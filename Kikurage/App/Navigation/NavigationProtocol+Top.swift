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
        let vc = LoginViewController()
        push(to: vc)
    }

    func pushToSignUp() {
        guard let vc = R.storyboard.signUpViewController.instantiateInitialViewController() else {
            return
        }
        push(to: vc)
    }

    func pushToDeviceRegister() {
        guard let vc = R.storyboard.deviceRegisterViewController.instantiateInitialViewController() else {
            return
        }
        push(to: vc)
    }

    func pushToHome(kikurageState: KikurageState, kikurageUser: KikurageUser) {
        guard let vc = R.storyboard.homeViewController.instantiateInitialViewController() else {
            return
        }
        vc.kikurageUser = kikurageUser
        vc.kikurageState = kikurageState
        push(to: vc)
    }

    // MARK: - SafariView

    func presentToSafariView(from vc: UIViewController, urlString: String?, onError: (() -> Void)?) {
        presentSafariView(from: vc, urlString: urlString, onError: onError)
    }
}
