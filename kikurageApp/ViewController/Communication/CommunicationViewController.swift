//
//  hakaseViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

class CommunicationViewController: UIViewController {
    /// BaseView
    private var baaseView: CommunicationBaseView { self.view as! CommunicationBaseView } // swiftlint:disable:this force_cast

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension CommunicationViewController {
    private func setNavigationItem() {
        // ナビゲーションバーの体裁を設定
        self.setNavigationBar(title: "みんなにそうだん")
    }
    private func setDelegateDataSource() {
        self.baaseView.delegate = self
    }
}
// MARK: - CommunicationBaseView Delegate
extension CommunicationViewController: CommunicationBaseViewDelegate {
    func didTapFacebookButton() {
        // Facebookのきくらげコミュニティへ遷移させる
        self.transitionSafariViewController(urlString: Constants.WebUrl.facebook)
    }
}
