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
    public var date: Date {
        datePicker.date
    }

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
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current

        inputView = datePicker
    }
}
