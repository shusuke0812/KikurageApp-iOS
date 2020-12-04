//
//  MainBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class MainBaseView: UIView {
    @IBOutlet weak var nowTimeLabel: UILabel!
    @IBOutlet weak var kikurageNameLabel: UILabel!
    @IBOutlet weak var kikurageStatusLabel: UILabel!
    @IBOutlet weak var kikurageStatusView: UIImageView!
    @IBOutlet weak var temparatureTextLabel: UILabel!
    @IBOutlet weak var humidityTextLabel: UILabel!
    @IBOutlet weak var kikurageAdviceView: MainAdviceView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
}

extension MainBaseView {
    private func initUI() {
        self.nowTimeLabel.text = "現在時刻を読み込み中..."
        self.kikurageNameLabel.text = "きくらげ名"
        self.kikurageStatusLabel.text = "きくらげの状態メッセージ"
        self.kikurageStatusView.image = UIImage(named: "normal_01")
        self.temparatureTextLabel.text = "-"
        self.humidityTextLabel.text = "-"
    }
}
