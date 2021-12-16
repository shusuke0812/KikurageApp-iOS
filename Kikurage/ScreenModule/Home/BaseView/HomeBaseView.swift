//
//  MainBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol HomeBaseViewDelegate: AnyObject {
    /// 栽培記録ボタンを押した時の処理
    func didTapCultivationButton()
    /// 料理記録ボタンを押した時の処理
    func didTapRecipeButton()
    /// 相談ボタンを押した時の処理
    func didTapCommunicationButton()
    /// サイドメニュー用のハンバーガーアイコンを押した時の処理
    func didTapSideMenuButton()
}

class HomeBaseView: UIView {
    @IBOutlet private weak var nowTimeLabel: UILabel!
    @IBOutlet private weak var kikurageNameLabel: UILabel!
    @IBOutlet private weak var kikurageStatusLabel: UILabel!
    @IBOutlet private weak var kikurageStatusView: UIImageView!
    @IBOutlet private weak var temperatureTitleLabel: UILabel!
    @IBOutlet private weak var temparatureTextLabel: UILabel!
    @IBOutlet private weak var humidityTitleLabel: UILabel!
    @IBOutlet private weak var humidityTextLabel: UILabel!
    @IBOutlet private weak var nowValueTitleLabel: UILabel!
    @IBOutlet private weak var expectedValueTitleLabel: UILabel!
    @IBOutlet private weak var expectedTemperatureLabel: UILabel!
    @IBOutlet private weak var expectedHumidityLabel: UILabel!
    @IBOutlet private weak var kikurageAdviceView: HomeAdviceView!

    weak var delegate: HomeBaseViewDelegate?

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
extension HomeBaseView {
    private func initUI() {
        nowTimeLabel.text = DateHelper.now()
        kikurageNameLabel.text = ""
        kikurageStatusLabel.text = ""
        displayKikurageStateImage(type: "normal")
        
        nowValueTitleLabel.text = R.string.localizable.screen_home_temperature_humidity_now_title()
        expectedValueTitleLabel.text = R.string.localizable.screen_home_temperature_humidity_expected_title()
        
        temperatureTitleLabel.text = R.string.localizable.screen_home_temperature_title()
        temparatureTextLabel.text = "-"
        expectedTemperatureLabel.text = "20-25°C"
        
        humidityTitleLabel.text = R.string.localizable.screen_home_humidity_title()
        humidityTextLabel.text = "-"
        expectedHumidityLabel.text = "80% " + R.string.localizable.screen_home_humidity_expected_suffix()
    }
}
// MARK: - Setting UI
extension HomeBaseView {
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
            kikurageNameLabel.text = R.string.localizable.screen_home_kikurage_name(name)
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
// MARK: - Animation
extension HomeBaseView {
    func kikurageStatusViewAnimation(_ animation: Bool) {
        (animation == true) ? kikurageStatusView.startAnimating() : kikurageStatusView.stopAnimating()
    }
}
