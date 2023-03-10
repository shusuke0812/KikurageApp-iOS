//
//  hakaseViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import PKHUD
import UIKit

class CommunicationViewController: UIViewController, UIViewControllerNavigatable, CommunicationAccessable {
    private var baaseView: CommunicationBaseView { self.view as! CommunicationBaseView } // swiftlint:disable:this force_cast

    // MARK: - Lifecycle

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
        baaseView.delegate = self
    }
}

// MARK: - CommunicationBaseView Delegate

extension CommunicationViewController: CommunicationBaseViewDelegate {
    func communicationBaseViewDidTapFacebookButton(_ communicationBaseView: CommunicationBaseView) {
        let urlString = AppConfig.shared.facebookGroupURL
        presentToSafariView(from: self, urlString: urlString, onError: nil)
    }
}
