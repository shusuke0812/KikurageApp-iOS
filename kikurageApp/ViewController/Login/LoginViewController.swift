//
//  LoginViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    /// BaseView
    private var baseView: LoginBaseView { self.view as! LoginBaseView } // swiftlint:disable:this force_cast

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "ログイン"
    }
}

// MARK: - Initialized
extension LoginViewController {
}
