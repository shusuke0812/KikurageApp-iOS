//
//  MainAdviceView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/26.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class HomeAdviceView: XibView {
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var adviceIconImageView: UIImageView!
    @IBOutlet private weak var adviceTitleLabel: UILabel!
    @IBOutlet weak var adviceContentLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBaseView()
        initAdviceTitleLabel()
        initAdviceIconImageView()
    }
}

extension HomeAdviceView {
    private func initBaseView() {
        baseView.clipsToBounds = true
        baseView.layer.cornerRadius = .viewCornerRadius
        baseView.backgroundColor = .white
    }
    private func initAdviceTitleLabel() {
        adviceTitleLabel.text = R.string.localizable.screen_home_advice_title()
    }
    private func initAdviceIconImageView() {
        adviceIconImageView.image = R.image.hakase()
    }
}
