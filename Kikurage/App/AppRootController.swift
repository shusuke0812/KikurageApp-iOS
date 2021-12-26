//
//  AppRootController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class AppRootController: UIViewController {
    private var currentViewController: UIViewController?
    private var presenter: AppPresenter!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AppPresenter(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository(), firebaseRemoteCofigRepository: FirebaseRemoteConfigRepository())
        presenter.delegate = self

        fetchRemoteConfig()

        if let userId = LoginHelper.shared.kikurageUserId {
            presenter.loadKikurageUser(userId: userId)
        } else {
            showTopPage()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Initialized

extension AppRootController {
    private func fetchRemoteConfig() {
        presenter.loadFacebookGroupUrl()
        presenter.loadTermsUrl()
        presenter.loadPrivacyPolicyUrl()
    }
}

// MARK: - Transition

extension AppRootController {
    /// ホーム画面を開く
    private func showHomePage(kikurageInfo: (user: KikurageUser?, state: KikurageState?)) {
        guard let vc = R.storyboard.homeViewController.instantiateInitialViewController() else { return }
        vc.kikurageUser = kikurageInfo.user
        vc.kikurageState = kikurageInfo.state
        let nc = UINavigationController(rootViewController: vc)
        changeViewController(nc)
    }
    /// ログイン画面を開く
    private func showTopPage() {
        guard let vc = R.storyboard.topViewController.instantiateInitialViewController() else { return }
        let nc = UINavigationController(rootViewController: vc)
        changeViewController(nc)
    }
    private func changeViewController(_ vc: UIViewController) {
        removeCurrentViewController()
        setCurrentViewController(vc)
        setScreenHeaderHeight(vc)
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
        vc.removeFromParent()
    }
}

// MARK: - AppPresenter Delegate

extension AppRootController: AppPresenterDelegate {
    func didSuccessGetKikurageInfo(kikurageInfo: (user: KikurageUser?, state: KikurageState?)) {
        DispatchQueue.main.async {
            self.showHomePage(kikurageInfo: kikurageInfo)
        }
    }
    func didFailedGetKikurageInfo(errorMessage: String) {
        print("DEBUG: \(errorMessage)")
        DispatchQueue.main.async {
            self.showTopPage()
        }
    }
}

// MARK: - Config

extension AppRootController {
    private func setScreenHeaderHeight(_ vc: UIViewController) {
        let nc = vc as? UINavigationController
        AppConfig.shared.navigationBarHeight = nc?.navigationBar.frame.size.height
        AppConfig.shared.safeAreaHeight = vc.view.window?.windowScene?.statusBarManager?.statusBarFrame.height
    }
}
