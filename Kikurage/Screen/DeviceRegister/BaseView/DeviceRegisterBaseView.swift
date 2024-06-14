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
    private(set) var kikurageQrcodeReaderView: KikurageQRCodeReaderView!
    private var kikurageQrcodeReaderViewHeightConstraint: NSLayoutConstraint!
    private var deviceRegisterButton: KUIButton!
    private var kikurageQrcodeReaderButton: UIButton!

    private let kikurageQrcodeReaderViewHeight: CGFloat = 240

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
        
        kikurageQrcodeReaderButton = UIButton(type: .system)
        kikurageQrcodeReaderButton.setTitle(R.string.localizable.screen_device_register_qrcode_btn_name(), for: .normal)
        kikurageQrcodeReaderButton.translatesAutoresizingMaskIntoConstraints = false

        kikurageQrcodeReaderViewHeightConstraint.constant = kikurageQrcodeReaderViewHeight
        kikurageQrcodeReaderView.backgroundColor = .white
        kikurageQrcodeReaderView.translatesAutoresizingMaskIntoConstraints = false
        
        deviceRegisterButton = KUIButton(props: KUIButtonProps(
            variant: .primary,
            title: R.string.localizable.screen_device_register_register_btn_name()
        ))

        addSubview(productKeyTextField)
        addSubview(kikurageNameTextField)
        addSubview(cultivationStartDateTextField)
        addSubview(kikurageQrcodeReaderButton)
        addSubview(kikurageQrcodeReaderView)
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
            
            kikurageQrcodeReaderButton.topAnchor.constraint(equalTo: cultivationStartDateTextField.bottomAnchor, constant: 15),
            kikurageQrcodeReaderButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            kikurageQrcodeReaderButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            kikurageQrcodeReaderView.topAnchor.constraint(equalTo: kikurageQrcodeReaderButton.bottomAnchor, constant: 15),
            kikurageQrcodeReaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            kikurageQrcodeReaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            kikurageQrcodeReaderView.heightAnchor.constraint(equalToConstant: 240),
            
            deviceRegisterButton.topAnchor.constraint(equalTo: kikurageQrcodeReaderView.bottomAnchor, constant: 15),
            deviceRegisterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            deviceRegisterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
        ])
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
        kikurageQrcodeReaderButton.addAction(.init { [weak self] _ in
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
        kikurageQrcodeReaderView.isHidden = isHidden
        kikurageQrcodeReaderViewHeightConstraint.constant = isHidden ? 0 : kikurageQrcodeReaderViewHeight
    }

    func setProductKeyText(_ text: String) {
        productKeyTextField.text = text
    }
}
