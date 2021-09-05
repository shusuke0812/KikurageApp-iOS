//
//  SignUpViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    /// BaseView
    private var baseView: SignUpBaseView { self.view as! SignUpBaseView } // swiftlint:disable:this force_cast

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "ユーザー登録"
    }
}
