//
//  MainAdviceView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/26.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class MainAdviceView: XibView {
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

extension MainAdviceView {
    private func initBaseView() {
        baseView.layer.cornerRadius = 18
        baseView.layer.borderColor = UIColor.red.cgColor
        baseView.layer.borderWidth = 1.0
    }
    private func initAdviceTitleLabel() {
        adviceTitleLabel.text = "【アドバイス】"
    }
    private func initAdviceIconImageView() {
        adviceIconImageView.image = R.image.hakase()
    }
}
