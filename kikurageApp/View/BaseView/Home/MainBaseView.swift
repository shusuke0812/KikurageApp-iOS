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
    @IBOutlet weak var nowTimeLabel: UILabel!
    @IBOutlet weak var kikurageNameLabel: UILabel!
    @IBOutlet weak var kikurageStatusLabel: UILabel!
    @IBOutlet weak var kikurageStatusView: UIImageView!
    @IBOutlet weak var temparatureTextLabel: UILabel!
    @IBOutlet weak var humidityTextLabel: UILabel!
    @IBOutlet weak var kikurageAdviceView: MainAdviceView!
    // ヘルパークラス
    private let kikurageStateHelper = KikurageStateHelper()
    // デリゲート
    internal weak var delegate: MainBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    // MARK: - Action Method
    @IBAction private func didTapCultivationButton(_ sender: Any) {
        self.delegate?.didTapCultivationButton()
    }
    @IBAction private func didTapRecipeButton(_ sender: Any) {
        self.delegate?.didTapRecipeButton()
    }
    @IBAction private func didTapCommunicationButton(_ sender: Any) {
        self.delegate?.didTapCommunicationButton()
    }
    @IBAction private func didTapSideMenuButton(_ sender: Any) {
        self.delegate?.didTapSideMenuButton()
    }
}
// MARK: - Initialized Method
extension MainBaseView {
    private func initUI() {
        self.nowTimeLabel.text = ClockHelper.shared.display()
        self.kikurageNameLabel.text = "きくらげ名"
        self.kikurageStatusLabel.text = "きくらげの状態メッセージ"
        self.displayKikurageStateImage(type: "normal")
        self.temparatureTextLabel.text = "-"
        self.humidityTextLabel.text = "-"
    }
}
// MARK: - Setting UI Method
extension MainBaseView {
    func setKikurageStateUI(kikurageState: KikurageState?) {
        // きくらげの状態メッセージを設定
        if let message: String = kikurageState?.message {
            self.kikurageStatusLabel.text = message
        }
        // きくらげの表情を設定
        if let judge: String = kikurageState?.judge {
            self.displayKikurageStateImage(type: judge)
        }
        // 温度湿度を設定
        if let temparature: Int = kikurageState?.temperature, let humidity: Int = kikurageState?.humidity {
            self.temparatureTextLabel.text = "\(temparature)"
            self.humidityTextLabel.text = "\(humidity)"
        }
        // アドバイスを設定
        if let advice: String = kikurageState?.advice {
            self.kikurageAdviceView.adviceContentLabel.text = advice
        }
    }
    // きくらげ名を設定
    func setKikurageNameUI(kikurageUser: KikurageUser?) {
        if let name: String = kikurageUser?.kikurageName {
            self.kikurageNameLabel.text = "今日の \(name)"
        }
    }
    // 時刻表示更新用メソッド
    func updateTimeLabel() {
        self.nowTimeLabel.text = ClockHelper.shared.display()
    }
    private func displayKikurageStateImage(type: String) {
        // 2つの画像を交互に表示する処理（アニメーションのSTOPはViewWillDisapperへ記載）
        self.kikurageStatusView.animationImages = kikurageStateHelper.setStateImage(type: type)
        self.kikurageStatusView.animationDuration = 1
        self.kikurageStatusView.animationRepeatCount = 0
        self.kikurageStatusView.startAnimating()
    }
}
