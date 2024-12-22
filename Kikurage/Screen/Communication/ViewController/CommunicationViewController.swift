//
//  CommunicationViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import PKHUD
import UIKit

class CommunicationViewController: UIViewController, UIViewControllerNavigatable, CommunicationAccessable {
    private var baseView: CommunicationBaseView = .init()

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setDelegateDataSource()
        adjustNavigationBarBackgroundColor()
    }
}

// MARK: - Initialized

extension CommunicationViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_communication_title())
    }

    private func setDelegateDataSource() {
        baseView.delegate = self
    }
}

// MARK: - CommunicationBaseView Delegate

extension CommunicationViewController: CommunicationBaseViewDelegate {
    func communicationBaseViewDidTapFacebookButton(_ communicationBaseView: CommunicationBaseView) {
        FirebaseAnalyticsHelper.sendTapEvent(.communicationFacebookButton)
        let urlString = AppConfig.shared.facebookGroupURL
        presentToSafariView(from: self, urlString: urlString, onError: nil)
    }
}
