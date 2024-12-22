//
//  KUIDropdownTextField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/15.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public enum KUIDropdownTextFieldVariant {
    case date
}

public struct KUIDropDownTextFieldProps {
    let variant: KUIDropdownTextFieldVariant
    let textFieldProps: KUITextFieldProps

    public init(
        variant: KUIDropdownTextFieldVariant,
        textFieldProps: KUITextFieldProps
    ) {
        self.variant = variant
        self.textFieldProps = textFieldProps
    }
}

public class KUIDropdownTextField: KUITextField {
    @available(*, deprecated, message: "Use onDidEndEditing call back")
    public var date: Date {
        datePicker.date
    }

    public var onDidEndEditing: ((Date) -> Void)?

    private let datePicker = UIDatePicker()

    public init(props: KUIDropDownTextFieldProps) {
        super.init(props: props.textFieldProps)
        setupComponent(variant: props.variant)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent(variant: KUIDropdownTextFieldVariant) {
        switch variant {
        case .date:
            setupDatePicker()
        }
    }

    private func setupDatePicker() {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onTapDone))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 44)
        toolbar.setItems([flexSpaceItem, doneButtonItem], animated: true)

        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.addTarget(self, action: #selector(onSetDateText), for: .valueChanged)

        inputView = datePicker
        inputAccessoryView = toolbar
    }

    @objc private func onTapDone() {
        resignFirstResponder()
        onDidEndEditing?(datePicker.date)
    }

    @objc private func onSetDateText() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale.current
        text = formatter.string(from: datePicker.date)
    }
}
