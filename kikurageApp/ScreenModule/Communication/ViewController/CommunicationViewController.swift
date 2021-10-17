//
//  hakaseViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

class CommunicationViewController: UIViewController, UIViewControllerNavigatable {
    private var baaseView: CommunicationBaseView { self.view as! CommunicationBaseView } // swiftlint:disable:this force_cast

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension CommunicationViewController {
    private func setNavigationItem() {
        setNavigationBar(title: "みんなにそうだん")
    }
    private func setDelegateDataSource() {
        baaseView.delegate = self
    }
}
// MARK: - CommunicationBaseView Delegate
extension CommunicationViewController: CommunicationBaseViewDelegate {
    func didTapFacebookButton() {
        transitionSafariViewController(urlString: Constants.WebUrl.facebook)
    }
}
