//
//  AppRootController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/9/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class AppRootController: UIViewController {
    private var currentViewController: UIViewController?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginPage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Private
extension AppRootController {
    /// ログイン画面を開く
    private func showLoginPage() {
        guard let vc = R.storyboard.loginViewController.instantiateInitialViewController() else { return }
        changeViewController(vc)
    }
    private func changeViewController(_ vc: UIViewController) {
        removeCurrentViewController()
        setCurrentViewController(vc)
    }
    private func setCurrentViewController(_ vc: UIViewController) {
        currentViewController = vc
        addChild(vc)
        view.addSubview(vc.view)
        didMove(toParent: vc)
    }
    private func removeCurrentViewController() {
        guard let vc = currentViewController else { return }
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
    }
}
