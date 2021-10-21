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

    weak var delegate: DeviceRegisterBaseViewDelegate?

    var datePicker = UIDatePicker()

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        initDatePicker()
    }
    // MARK: - Action
    @IBAction private func didTappedDeviceRegisterButton(_ sender: Any) {
        delegate?.didTappedDeviceRegisterButton()
    }
}
// MARK: - Initialized
extension DeviceRegisterBaseView {
    private func initUI() {
        deviceRegisterButton.layer.masksToBounds = true
        deviceRegisterButton.layer.cornerRadius = 5

        productKeyTextField.autocorrectionType = .no
    }
    private func initDatePicker() {
        // DatePcikerの基本設定
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        // TextFieldの入力にDatePickerを接続
        cultivationStartDateTextField.inputView = datePicker
    }
}