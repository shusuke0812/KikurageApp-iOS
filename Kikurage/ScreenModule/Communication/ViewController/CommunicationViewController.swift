//
//  hakaseViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class CommunicationViewController: UIViewController, UIViewControllerNavigatable {
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
    func didTapFacebookButton() {
        if let urlString = AppConfig.shared.facebookGroupUrl {
            transitionSafariViewController(urlString: urlString)
        } else {
            // TODO: Facebookを開けないアラートを出す
        }
    }
}
