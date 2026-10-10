//
//  CommunicationViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import KAAnalytics
import KSAppService
import UIKit

class CommunicationViewController: UIViewController, UIViewControllerNavigatable, CommunicationAccessable {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let baseView = CommunicationBaseView(delegate: self)
        addBaseView(baseView: baseView)

        setNavigationItem()
        adjustNavigationBarBackgroundColor()
    }
}

// MARK: - Initialized

extension CommunicationViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_communication_title())
    }
}

// MARK: - CommunicationBaseView Delegate

extension CommunicationViewController: CommunicationBaseViewDelegate {
    func communicationBaseViewDidTapFacebookButton() {
        FirebaseAnalyticsManager.sendTapEvent(.communicationFacebookButton)
        let urlString = AppConfig.shared.facebookGroupURLString
        presentToSafariView(urlString: urlString, onError: nil)
    }
}
