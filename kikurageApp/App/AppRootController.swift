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
        self.presenter = AppPresenter(kikurageUserRepository: KikurageUserRepository())
        self.presenter.delegate = self

        self.presenter.checkSavedUserId()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Private
extension AppRootController {
    /// トップ画面を開く
    private func showTopPage(kikurageUser: KikurageUser) {
        guard let vc = R.storyboard.mainViewController.instantiateInitialViewController() else { return }
        let navVC = UINavigationController(rootViewController: vc)
        let mainVC = navVC.topViewController as! MainViewController // swiftlint:disable:this force_cast
        mainVC.kikurageUser = kikurageUser
        changeViewController(mainVC)
    }
    /// ログイン画面を開く
    private func showLoginPage() {
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
    }
}

// MARK: - AppPresenter Delegate
extension AppRootController: AppPresenterDelegate {
    func didSuccessGetKikurageUser(kikurageUser: KikurageUser) {
        showTopPage(kikurageUser: kikurageUser)
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        print("DEBUG: \(errorMessage)")
        showLoginPage()
    }
}
