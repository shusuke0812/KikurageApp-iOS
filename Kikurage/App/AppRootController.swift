//
//  AppRootController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import KikurageFeature

class AppRootController: UIViewController {
    private var currentViewController: UIViewController?
    private var presenter: AppPresenter!

    private let kikurageHUD: KikurageHUD = {
        let hud = KikurageHUD()
        hud.startRotateAnimation(duration: 1.0, rotateAxis: .y)
        hud.translatesAutoresizingMaskIntoConstraints = false
        return hud
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initHUD()

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
        if let vc = currentViewController {
            setScreenHeaderHeight(vc)
        }
    }
}

// MARK: - Initialized

extension AppRootController {
    private func fetchRemoteConfig() {
        presenter.loadFacebookGroupUrl()
        presenter.loadTermsUrl()
        presenter.loadPrivacyPolicyUrl()
    }
    private func initHUD() {
        view.addSubview(kikurageHUD)

        NSLayoutConstraint.activate([
            kikurageHUD.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kikurageHUD.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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

        kikurageHUD.stopRotateAnimation()
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
    // FIXME: `setScreenHeaderHeight()`は一度だけ呼ぶようにしたい（現状はトップ画面・ホーム画面のview更新タイミングが違い、satatus bar heightを取得できるタイミングが異なるため２箇所で呼んでいる）
    private func setScreenHeaderHeight(_ vc: UIViewController) {
        let nc = vc as? UINavigationController
        AppConfig.shared.navigationBarHeight = nc?.navigationBar.frame.size.height
        AppConfig.shared.safeAreaHeight = vc.view.window?.windowScene?.statusBarManager?.statusBarFrame.height
    }
}
