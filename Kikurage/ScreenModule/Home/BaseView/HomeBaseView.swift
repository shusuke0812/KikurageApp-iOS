//
//  MainBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol HomeBaseViewDelegate: AnyObject {
    func homeBaseViewDidTappedCultivationButton(_ homeBaseView: HomeBaseView)
    func homeBaseViewDidTappedRecipeButton(_ homeBaseView: HomeBaseView)
    func homeBaseViewDidTappedCommunicationButton(_ homeBaseView: HomeBaseView)
    func homeBaseViewDidTappedSideMenuButton(_ homeBaseView: HomeBaseView)
}

class HomeBaseView: UIView {
    @IBOutlet private weak var kikurageNameLabel: UILabel!
    @IBOutlet private weak var kikurageStatusLabel: UILabel!

    @IBOutlet private weak var kikurageStatusParentView: UIView!
    @IBOutlet private weak var kikurageStatusImageView: UIImageView!
    @IBOutlet private weak var nowTimeLabel: UILabel!

    @IBOutlet private weak var valueParentView: UIView!
    @IBOutlet private weak var temperatureTitleLabel: UILabel!
    @IBOutlet private weak var temparatureTextLabel: UILabel!
    @IBOutlet private weak var humidityTitleLabel: UILabel!
    @IBOutlet private weak var humidityTextLabel: UILabel!
    @IBOutlet private weak var nowValueTitleLabel: UILabel!
    @IBOutlet private weak var expectedValueTitleLabel: UILabel!
    @IBOutlet private weak var expectedTemperatureLabel: UILabel!
    @IBOutlet private weak var expectedHumidityLabel: UILabel!

    @IBOutlet private weak var kikurageAdviceView: HomeAdviceView!
    @IBOutlet private weak var footerButtonView: FooterButtonView!

    private var kikurageStateEmptyView: UIView!

    weak var delegate: HomeBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        initFailedUI()
        footerButtonView.delegate = self
    }

    // MARK: - Action

    @IBAction private func openSideMenu(_ sender: Any) {
        delegate?.homeBaseViewDidTappedSideMenuButton(self)
    }
}

// MARK: - Initialized

extension HomeBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        nowTimeLabel.text = DateHelper.now()
        kikurageNameLabel.text = ""
        kikurageStatusLabel.text = ""

        kikurageStatusParentView.clipsToBounds = true
        kikurageStatusParentView.layer.cornerRadius = .viewCornerRadius

        valueParentView.backgroundColor = .systemGroupedBackground
        nowValueTitleLabel.text = R.string.localizable.screen_home_temperature_humidity_now_title()
        expectedValueTitleLabel.text = R.string.localizable.screen_home_temperature_humidity_expected_title()

        temperatureTitleLabel.text = R.string.localizable.screen_home_temperature_title()
        temparatureTextLabel.text = "-"
        expectedTemperatureLabel.text = "20-25°C"

        humidityTitleLabel.text = R.string.localizable.screen_home_humidity_title()
        humidityTextLabel.text = "-"
        expectedHumidityLabel.text = "80% " + R.string.localizable.screen_home_humidity_expected_suffix()
    }
    private func initFailedUI() {
        kikurageStateEmptyView = UIView()
        kikurageStateEmptyView.backgroundColor = .white
        kikurageStateEmptyView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = R.string.localizable.common_read_error()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false

        kikurageStateEmptyView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: kikurageStateEmptyView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: kikurageStateEmptyView.centerYAnchor)
        ])
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
        if let type: KikurageStateType = kikurageState?.type {
            displayKikurageStateImage(type: type)
        } else {
            displayFailedKikurageStateImage()
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
        #if PRODUCTION
        nowTimeLabel.isHidden = true
        #endif
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
    private func displayKikurageStateImage(type: KikurageStateType) {
        kikurageStateEmptyView.removeFromSuperview()
        // 2つの画像を交互に表示する処理（アニメーションのSTOPはViewWillDisapperへ記載）
        kikurageStatusImageView.animationImages = KikurageStateHelper.setStateImage(type: type)
        kikurageStatusImageView.animationDuration = 1
        kikurageStatusImageView.animationRepeatCount = 0
        kikurageStatusImageView.startAnimating()
    }
    private func displayFailedKikurageStateImage() {
        kikurageStatusImageView.addSubview(kikurageStateEmptyView)
        kikurageStatusImageView.image = nil

        NSLayoutConstraint.activate([
            kikurageStateEmptyView.topAnchor.constraint(equalTo: kikurageStatusImageView.topAnchor),
            kikurageStateEmptyView.leadingAnchor.constraint(equalTo: kikurageStatusImageView.leadingAnchor),
            kikurageStateEmptyView.trailingAnchor.constraint(equalTo: kikurageStatusImageView.trailingAnchor),
            kikurageStateEmptyView.bottomAnchor.constraint(equalTo: kikurageStatusImageView.bottomAnchor)
        ])
    }
}

// MARK: - Animation

extension HomeBaseView {
    func kikurageStatusViewAnimation(_ animation: Bool) {
        (animation == true) ? kikurageStatusImageView.startAnimating() : kikurageStatusImageView.stopAnimating()
    }
}

// MARK: - FooterButtonView Delegate

extension HomeBaseView: FooterButtonViewDelegate {
    func footerButtonViewDidTapCultivationButton(_ footerButtonView: FooterButtonView) {
        delegate?.homeBaseViewDidTappedCultivationButton(self)
    }
    func footerButtonViewDidTapRecipeButton(_ footerButtonView: FooterButtonView) {
        delegate?.homeBaseViewDidTappedRecipeButton(self)
    }
    func footerButtonViewDidTapCommunicationButton(_ footerButtonView: FooterButtonView) {
        delegate?.homeBaseViewDidTappedCommunicationButton(self)
    }
}
