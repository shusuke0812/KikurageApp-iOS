//
//  hakaseViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

class CommunicationViewController: UIViewController {
    
    /// BaaseView
    private var baaseView: CommunicationBaseView { self.view as! CommunicationBaseView }

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
// MARK: - CommunicationBaseView Delegate Method
extension CommunicationViewController: CommunicationBaseViewDelegate {
    func didTapFacebookButton() {
        // Facebookのきくらげコミュニティへ遷移させる
        self.transitionSafariViewController(urlString: Constants.WebUrl.facebook)
    }
}
