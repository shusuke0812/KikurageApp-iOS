//
//  DebugViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

class DebugViewController: UIViewController {
    private var baseView: DebugBaseView = .init()
    private var viewModel: DebugViewModel!

    private let konashi = KonashiBluetooth()

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        baseView.delegate = self
        viewModel = DebugViewModel()

        konashi.delegate = self
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

    func debugBaseViewDidTappedKonashiFind(_ debugBaseView: DebugBaseView) {
        konashi.find()
        konashi.readRSSI()
    }
}

// MARK: - KonashiBluetooth Delegate

extension DebugViewController: KonashiBluetoothDelegate {
    func konashiBluetooth(_ konashiBluetooth: KonashiBluetooth, didUpdated rssi: Int32) {
        let rssiString = String(rssi)
        DispatchQueue.main.async {
            self.baseView.setRSSILabel(rssiString)
        }
    }

    func konashiBluetoothDisconnected(_ konashiBluetooth: KonashiBluetooth) {
        DispatchQueue.main.async {
            self.baseView.setRSSILabel("disconnected")
        }
    }

    func konashiBluetoothDidUpdatedPIOInput(_ konashiBluetooth: KonashiBluetooth, message: String) {
        DispatchQueue.main.async {
            self.baseView.setPIOLabel(message)
        }
    }
}
