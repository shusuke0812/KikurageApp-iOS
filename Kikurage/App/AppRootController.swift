//
//  AppRootController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KUIKit
import SwiftUI
import UIKit

class AppRootController: UIViewController {
    private var currentViewController: UIViewController?
    private let viewModel = AppViewModel()
    private var effectObservationTask: Task<Void, Never>?
    private var hudHostingController: UIHostingController<KUIHUD>?

    deinit {
        effectObservationTask?.cancel()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        showHUD()

        observeEffect()
        viewModel.fetchRemoteConfig()
        viewModel.verifyLogin()
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
    private func showHUD() {
        let hostingController = UIHostingController(rootView: KUIHUD())
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        hudHostingController = hostingController
    }

    private func hideHUD() {
        hudHostingController?.willMove(toParent: nil)
        hudHostingController?.view.removeFromSuperview()
        hudHostingController?.removeFromParent()
        hudHostingController = nil
    }
}

// MARK: - Transition

extension AppRootController {
    private func showHomePage(productKey: String, userId: String) {
        let vc = HomeViewController(productKey: productKey, userId: userId)
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

        hideHUD()
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

// MARK: - Effect

extension AppRootController {
    private func observeEffect() {
        effectObservationTask = Task { [weak self] in
            guard let self else { return }
            for await effect in self.viewModel.effects {
                DispatchQueue.main.async {
                    self.handleEffect(effect)
                }
            }
        }
    }

    private func handleEffect(_ effect: AppViewModel.Effect) {
        switch effect {
        case let .showHomePage(productKey, userId):
            showHomePage(productKey: productKey, userId: userId)
        case .showTopPage:
            showTopPage()
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
