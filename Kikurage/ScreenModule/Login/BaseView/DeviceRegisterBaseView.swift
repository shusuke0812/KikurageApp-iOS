//
//  LoginBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import KikurageFeature

protocol DeviceRegisterBaseViewDelegate: AnyObject {
    func deviceRegisterBaseViewDidTappedDeviceRegisterButton(_ deviceRegisterBaseView: DeviceRegisterBaseView)
    func deviceRegisterBaseViewDidTappedQrcodeReaderButton(_ deviceRegisterBaseView: DeviceRegisterBaseView)
}

class DeviceRegisterBaseView: UIView {
    @IBOutlet private(set) weak var productKeyTextField: UITextField!
    @IBOutlet private(set) weak var kikurageNameTextField: UITextField!
    @IBOutlet private(set) weak var cultivationStartDateTextField: UITextField!
    @IBOutlet private(set) weak var kikurageQrcodeReaderView: KikurageQRCodeReaderView!
    @IBOutlet private weak var kikurageQrcodeReaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var deviceRegisterButton: UIButton!
    @IBOutlet private weak var kikurageQrcodeReaderButton: UIButton!

    private let kikurageQrcodeReaderViewHeight: CGFloat = 240

    weak var delegate: DeviceRegisterBaseViewDelegate?

    var datePicker = UIDatePicker()

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        initDatePicker()
    }

    // MARK: - Action

    @IBAction private func registerDevice(_ sender: Any) {
        delegate?.deviceRegisterBaseViewDidTappedDeviceRegisterButton(self)
    }
    @IBAction private func openQrcodeReader(_ sender: Any) {
        delegate?.deviceRegisterBaseViewDidTappedQrcodeReaderButton(self)
    }
}

// MARK: - Initialized

extension DeviceRegisterBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        deviceRegisterButton.layer.masksToBounds = true
        deviceRegisterButton.layer.cornerRadius = .buttonCornerRadius
        deviceRegisterButton.setTitle(R.string.localizable.screen_device_register_register_btn_name(), for: .normal)

        productKeyTextField.autocorrectionType = .no
        productKeyTextField.placeholder = R.string.localizable.screen_device_register_productkey_textfield_placeholer()

        kikurageNameTextField.placeholder = R.string.localizable.screen_device_register_kikurage_name_textfield_placeholer()

        cultivationStartDateTextField.placeholder = R.string.localizable.screen_device_register_cultivation_start_date_textfield_placeholer()

        kikurageQrcodeReaderViewHeightConstraint.constant = kikurageQrcodeReaderViewHeight
        kikurageQrcodeReaderView.backgroundColor = .white

        kikurageQrcodeReaderButton.setTitle(R.string.localizable.screen_device_register_qrcode_btn_name(), for: .normal)
    }
    private func initDatePicker() {
        // DatePcikerの基本設定
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        // TextFieldの入力にDatePickerを接続
        cultivationStartDateTextField.inputView = datePicker
    }
}

// MARK: - Config

extension DeviceRegisterBaseView {
    func configTextField(delegate: UITextFieldDelegate) {
        productKeyTextField.delegate = delegate
        kikurageNameTextField.delegate = delegate
        cultivationStartDateTextField.delegate = delegate
    }
    func showKikurageQrcodeReaderView(isHidden: Bool) {
        kikurageQrcodeReaderView.isHidden = isHidden
        kikurageQrcodeReaderViewHeightConstraint.constant = isHidden ? 0 : kikurageQrcodeReaderViewHeight
    }
    func setProductKeyText(_ text: String) {
        productKeyTextField.text = text
    }
}
