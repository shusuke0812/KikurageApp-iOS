//
//  hakaseViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

class CommunicationViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    //MARK: - Action Method
    @IBAction func didTapFacebookButton(_ sender: Any) {
        // Facebookのきくらげコミュニティへ遷移させる
        self.transitionSafariViewController(urlString: Constants.Url.facebook)
    }
}
// MARK: - Initialized Method
extension CommunicationViewController {
    private func setUI() {
        // ナビゲーションバーの体裁を設定
        self.setNavigationBar(title: "みんなにそうだん")
    }
}
// MARK: - Private Method
extension CommunicationViewController {
}
