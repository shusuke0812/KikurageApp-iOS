//
//  MainBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol MainBaseViewDelegate: AnyObject {
    /// 栽培記録ボタンを押した時の処理
    func didTapCultivationButton()
    /// 料理記録ボタンを押した時の処理
    func didTapRecipeButton()
    /// 相談ボタンを押した時の処理
    func didTapCommunicationButton()
    /// サイドメニュー用のハンバーガーアイコンを押した時の処理
    func didTapSideMenuButton()
}

class MainBaseView: UIView {
    @IBOutlet private weak var nowTimeLabel: UILabel!
    @IBOutlet private weak var kikurageNameLabel: UILabel!
    @IBOutlet private weak var kikurageStatusLabel: UILabel!
    @IBOutlet weak var kikurageStatusView: UIImageView!
    @IBOutlet private weak var temparatureTextLabel: UILabel!
    @IBOutlet private weak var humidityTextLabel: UILabel!
    @IBOutlet private weak var kikurageAdviceView: MainAdviceView!

    weak var delegate: MainBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    // MARK: - Action Method
    @IBAction private func didTapCultivationButton(_ sender: Any) {
        delegate?.didTapCultivationButton()
    }
    @IBAction private func didTapRecipeButton(_ sender: Any) {
        delegate?.didTapRecipeButton()
    }
    @IBAction private func didTapCommunicationButton(_ sender: Any) {
        delegate?.didTapCommunicationButton()
    }
    @IBAction private func didTapSideMenuButton(_ sender: Any) {
        delegate?.didTapSideMenuButton()
    }
}
// MARK: - Initialized
extension MainBaseView {
    private func initUI() {
        nowTimeLabel.text = DateHelper.now()
        kikurageNameLabel.text = ""
        kikurageStatusLabel.text = ""
        displayKikurageStateImage(type: "normal")
        temparatureTextLabel.text = "-"
        humidityTextLabel.text = "-"
    }
}
// MARK: - Setting UI
extension MainBaseView {
    func setKikurageStateUI(kikurageState: KikurageState?) {
        // きくらげの状態メッセージを設定
        if let message: String = kikurageState?.message {
            kikurageStatusLabel.text = message
        }
        // きくらげの表情を設定
        if let judge: String = kikurageState?.judge {
            displayKikurageStateImage(type: judge)
        }
        // 温度湿度を設定
        if let temparature: Int = kikurageState?.temperature, let humidity: Int = kikurageState?.humidity {
            temparatureTextLabel.text = "\(temparature)"
            humidityTextLabel.text = "\(humidity)"
        }
        // アドバイスを設定
        if let advice: String = kikurageState?.advice {
            kikurageAdviceView.adviceContentLabel.text = advice
        }
    }
    /// きくらげ名を設定
    func setKikurageNameUI(kikurageUser: KikurageUser?) {
        if let name: String = kikurageUser?.kikurageName {
            kikurageNameLabel.text = "今日の \(name)"
        }
    }
    /// 時刻表示更新用メソッド
    func updateTimeLabel() {
        nowTimeLabel.text = DateHelper.now()
    }
    private func displayKikurageStateImage(type: String) {
        // 2つの画像を交互に表示する処理（アニメーションのSTOPはViewWillDisapperへ記載）
        kikurageStatusView.animationImages = KikurageStateHelper.setStateImage(type: type)
        kikurageStatusView.animationDuration = 1
        kikurageStatusView.animationRepeatCount = 0
        kikurageStatusView.startAnimating()
    }
}
