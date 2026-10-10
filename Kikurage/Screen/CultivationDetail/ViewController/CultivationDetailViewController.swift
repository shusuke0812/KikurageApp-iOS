//
//  CultivationDetailViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KAAnalytics
import KDEntity
import UIKit

class CultivationDetailViewController: UIViewController, UIViewControllerNavigatable {
    var cultivation: KikurageCultivation!

    override func viewDidLoad() {
        super.viewDidLoad()

        let baseView = CultivationDetailBaseView(cultivation: cultivation)
        addBaseView(baseView: baseView)

        setNavigationItem()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.cultivationDetail)
    }
}

// MARK: - Private

extension CultivationDetailViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_cultivation_detail_title())
    }
}
