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
    private func showMainPage(kikurageInfo: (user: KikurageUser?, state: KikurageState?)) {
        guard let nc = R.storyboard.mainViewController.instantiateInitialViewController() else { return }
        let vc = nc.topViewController as! MainViewController // swiftlint:disable:this force_cast
        vc.kikurageUser = kikurageInfo.user
        vc.kikurageState = kikurageInfo.state
        changeViewController(nc)
    }
    /// ログイン画面を開く
    private func showTopPage() {
        guard let vc = R.storyboard.topViewController.instantiateInitialViewController() else { return }
        let navVC = UINavigationController(rootViewController: vc)
        changeViewController(navVC)
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
        vc.removeFromParent()
    }
}

// MARK: - AppPresenter Delegate
extension AppRootController: AppPresenterDelegate {
    func didSuccessGetKikurageInfo(kikurageInfo: (user: KikurageUser?, state: KikurageState?)) {
        DispatchQueue.main.async {
            self.showMainPage(kikurageInfo: kikurageInfo)
        }
    }
    func didFailedGetKikurageInfo(errorMessage: String) {
        print("DEBUG: \(errorMessage)")
        DispatchQueue.main.async {
            self.showTopPage()
        }
    }
}
