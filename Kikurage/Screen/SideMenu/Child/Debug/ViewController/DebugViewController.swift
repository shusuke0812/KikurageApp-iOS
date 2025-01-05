//
//  DebugViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KSDebugService
import UIKit

class DebugViewController: UIViewController {
    private var baseView: DebugBaseView = .init()
    private var viewModel: DebugViewModel!

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        baseView.delegate = self
        viewModel = DebugViewModel()

        baseView.activityIndicatorView.startAnimating()
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
    func debugBaseViewDidTappedForceRestrart(_ debugBaseView: DebugBaseView) {
        LoginHelper.shared.logout()
    }
}
