//
//  LoginBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol DeviceRegisterBaseViewDelegate: AnyObject {
    /// ログインボタンを押した時の処理
    func didTappedDeviceRegisterButton()
}

class DeviceRegisterBaseView: UIView {
    @IBOutlet weak var productKeyTextField: UITextField!
    @IBOutlet weak var kikurageNameTextField: UITextField!
    @IBOutlet weak var cultivationStartDateTextField: UITextField!
    @IBOutlet private weak var deviceRegisterButton: UIButton!
    @IBOutlet private weak var copyRightLabel: UILabel!
    /// デリゲート
    weak var delegate: DeviceRegisterBaseViewDelegate?
    /// 日付選択Picker
    var datePicker = UIDatePicker()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        self.initTextFieldTag()
        self.initDatePicker()
    }
    // MARK: - Action
    @IBAction private func didTappedDeviceRegisterButton(_ sender: Any) {
        self.delegate?.didTappedDeviceRegisterButton()
    }
}
// MARK: - Initialized
extension DeviceRegisterBaseView {
    private func initUI() {
        self.deviceRegisterButton.layer.masksToBounds = true
        self.deviceRegisterButton.layer.cornerRadius = 5
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
