//
//  DebugViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController, UIViewControllerNavigatable {
    private var viewModel: DebugViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        viewModel = DebugViewModel()

        let baseView = DebugBaseView(delegate: self)
        let _ = addBaseView(baseView: baseView)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension DebugViewController {
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.side_menu_debug_title()
    }
}

// MARK: - DebugBaseView Delegate

extension DebugViewController: DebugBaseViewDelegate {
    func debugBaseViewDidTapForceRestart() {
        viewModel.logout { result in
            switch result {
            case .success:
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let rootVC = windowScene?.keyWindow?.rootViewController
                if rootVC is AppRootController, let rootVC = rootVC as? AppRootController {
                    rootVC.logout(rootVC: rootVC)
                } else {
                    // error: do nothing
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
