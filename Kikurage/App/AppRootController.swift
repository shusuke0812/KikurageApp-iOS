//
//  AppRootController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

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

        presenter = AppPresenter(firebaseRemoteCofigRepository: FirebaseRemoteConfigRepository())
        presenter.delegate = self

        fetchRemoteConfig()

        if LoginHelper.shared.isLogin {
            presenter.login()
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
        presenter.loadFacebookGroupURL()
        presenter.loadTermsURL()
        presenter.loadPrivacyPolicyURL()
        presenter.loadLatestAppVersion()
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
    private func showHomePage(kikurageInfo: (user: KikurageUser?, state: KikurageState?)) {
        guard let vc = R.storyboard.homeViewController.instantiateInitialViewController() else {
            return
        }
        vc.kikurageUser = kikurageInfo.user
        vc.kikurageState = kikurageInfo.state
        let nc = CustomNavigationController(rootViewController: vc)
        changeViewController(nc)
    }

    private func showTopPage() {
        let vc = TopViewController()
        let nc = CustomNavigationController(rootViewController: vc)
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
        guard let vc = currentViewController else {
            return
        }
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    func logout(rootVC: AppRootController) {
        closeAllViewControllers(rootVC: rootVC) { [weak self] in
            DispatchQueue.main.async {
                self?.showTopPage()
            }
        }
    }

    private func closeAllViewControllers(rootVC: AppRootController, completion: (() -> Void)?) {
        let nc = currentViewController as? CustomNavigationController
        nc?.popToRootViewController(animated: false)
        rootVC.dismiss(animated: false) {
            completion?()
        }
    }
}

// MARK: - AppPresenter Delegate

extension AppRootController: AppPresenterDelegate {
    func appPresenterDidSuccessGetKikurageInfo(_ appPresenter: AppPresenter?, kikurageInfo: (user: KikurageUser?, state: KikurageState?)) {
        if let user = kikurageInfo.user {
            FirebaseAnalyticsHelper.setUserProperty()
            FirebaseAnalyticsHelper.setUserID(user.productKey)
        }
        DispatchQueue.main.async {
            self.showHomePage(kikurageInfo: kikurageInfo)
        }
    }

    func appPresenterDidFailedGetKikurageInfo(_ appPresenter: AppPresenter?, errorMessage: String) {
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
