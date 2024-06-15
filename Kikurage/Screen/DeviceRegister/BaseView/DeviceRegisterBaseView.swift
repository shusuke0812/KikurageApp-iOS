//
//  DeviceRegisterBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageFeature
import KikurageUI
import UIKit

protocol DeviceRegisterBaseViewDelegate: AnyObject {
    func deviceRegisterBaseViewDidTappedDeviceRegisterButton(_ deviceRegisterBaseView: DeviceRegisterBaseView)
    func deviceRegisterBaseViewDidTappedQrcodeReaderButton(_ deviceRegisterBaseView: DeviceRegisterBaseView)
}

class DeviceRegisterBaseView: UIView {
    private(set) var productKeyTextField: KUITextField!
    private(set) var kikurageNameTextField: KUITextField!
    private(set) var cultivationStartDateTextField: KUITextField!
    private(set) var qrcodeReaderView: KikurageQRCodeReaderView!
    private var deviceRegisterButton: KUIButton!
    private var qrcodeReaderButton: UIButton!

    private var showQrcodeReaderViewConstraint: NSLayoutConstraint!
    private var hideQrcodeReaderViewConstraint: NSLayoutConstraint!

    weak var delegate: DeviceRegisterBaseViewDelegate?

    var datePicker = UIDatePicker()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupComponent()
        setupDatePicker()
        setupButtonAction()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        productKeyTextField = KUITextField(props: KUITextFieldProps(
            placeHolder: R.string.localizable.screen_device_register_productkey_textfield_placeholer()
        ))

        kikurageNameTextField = KUITextField(props: KUITextFieldProps(
            placeHolder: R.string.localizable.screen_device_register_kikurage_name_textfield_placeholer()
        ))

        cultivationStartDateTextField = KUITextField(props: KUITextFieldProps(
            placeHolder: R.string.localizable.screen_device_register_cultivation_start_date_textfield_placeholer()
        ))

        qrcodeReaderButton = UIButton(type: .system)
        qrcodeReaderButton.setTitle(R.string.localizable.screen_device_register_qrcode_btn_name(), for: .normal)
        qrcodeReaderButton.translatesAutoresizingMaskIntoConstraints = false

        qrcodeReaderView = KikurageQRCodeReaderView()
        qrcodeReaderView.backgroundColor = .white
        qrcodeReaderView.translatesAutoresizingMaskIntoConstraints = false

        deviceRegisterButton = KUIButton(props: KUIButtonProps(
            variant: .primary,
            title: R.string.localizable.screen_device_register_register_btn_name()
        ))

        addSubview(productKeyTextField)
        addSubview(kikurageNameTextField)
        addSubview(cultivationStartDateTextField)
        addSubview(qrcodeReaderButton)
        addSubview(qrcodeReaderView)
        addSubview(deviceRegisterButton)

        NSLayoutConstraint.activate([
            productKeyTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            productKeyTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            productKeyTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            kikurageNameTextField.topAnchor.constraint(equalTo: productKeyTextField.bottomAnchor, constant: 25),
            kikurageNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            kikurageNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            cultivationStartDateTextField.topAnchor.constraint(equalTo: kikurageNameTextField.bottomAnchor, constant: 25),
            cultivationStartDateTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            cultivationStartDateTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            qrcodeReaderButton.topAnchor.constraint(equalTo: cultivationStartDateTextField.bottomAnchor, constant: 15),
            qrcodeReaderButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            qrcodeReaderButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            qrcodeReaderView.topAnchor.constraint(equalTo: qrcodeReaderButton.bottomAnchor, constant: 15),
            qrcodeReaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            qrcodeReaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            deviceRegisterButton.topAnchor.constraint(equalTo: qrcodeReaderView.bottomAnchor, constant: 15),
            deviceRegisterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            deviceRegisterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            deviceRegisterButton.heightAnchor.constraint(equalToConstant: 45)
        ])

        showQrcodeReaderViewConstraint = qrcodeReaderView.heightAnchor.constraint(equalToConstant: 240)
        hideQrcodeReaderViewConstraint = qrcodeReaderView.heightAnchor.constraint(equalToConstant: 0)
    }

    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current

        cultivationStartDateTextField.inputView = datePicker
    }

    // MARK: - Action

    private func setupButtonAction() {
        deviceRegisterButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.deviceRegisterBaseViewDidTappedDeviceRegisterButton(self)
        }
        qrcodeReaderButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.deviceRegisterBaseViewDidTappedQrcodeReaderButton(self)
        }, for: .touchUpInside)
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
        qrcodeReaderView.isHidden = isHidden
        showQrcodeReaderViewConstraint.isActive = !isHidden
        hideQrcodeReaderViewConstraint.isActive = isHidden
    }

    func setProductKeyText(_ text: String) {
        productKeyTextField.text = text
    }
}
