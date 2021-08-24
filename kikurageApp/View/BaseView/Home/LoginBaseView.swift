//
//  LoginBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol LoginBaseViewDelegate: AnyObject {
    /// ログインボタンを押した時の処理
    func didTapLoginButton()
    /// 利用規約ボタンを押した時の処理
    func didTapTermsButton()
    /// 個人情報保護方針ボタンを押した時の処理
    func didTapPrivacyPolicyButton()
}

class LoginBaseView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var productKeyTextField: UITextField!
    @IBOutlet weak var kikurageNameTextField: UITextField!
    @IBOutlet weak var cultivationStartDateTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var copyRightLabel: UILabel!
    /// デリゲート
    weak var delegate: LoginBaseViewDelegate?
    /// 日付選択Picker
    var datePicker = UIDatePicker()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        self.initTextFieldTag()
        self.initDatePicker()
    }
    // MARK: - Action
    @IBAction private func didTapLoginButton(_ sender: Any) {
        self.delegate?.didTapLoginButton()
    }
    @IBAction private func didTapTermsButton(_ sender: Any) {
        self.delegate?.didTapTermsButton()
    }
    @IBAction private func didTapPrivacyPolicyButton(_ sender: Any) {
        self.delegate?.didTapPrivacyPolicyButton()
    }
}
// MARK: - Initialized
extension LoginBaseView {
    private func initUI() {
        // 画像
        self.imageView.image = UIImage(named: "kikurageDevice")
        // ログインボタンの体裁
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 5
        // コピーライト
        self.copyRightLabel.text = "©︎ チーム きくらげ大使館"
    }
    private func initTextFieldTag() {
        self.productKeyTextField.tag = Constants.TextFieldTag.productKey
        self.kikurageNameTextField.tag = Constants.TextFieldTag.kikurageName
        self.cultivationStartDateTextField.tag = Constants.TextFieldTag.cultivationStartDate
    }
    private func initDatePicker() {
        // DatePcikerの基本設定
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.datePickerMode = .date
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.locale = Locale.current
        // TextFieldの入力にDatePickerを接続
        self.cultivationStartDateTextField.inputView = self.datePicker
    }
}
