//
//  KUITextField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUITextFieldProps {
    let placeHolder: String
    let accessibilityIdentifier: String?

    public init(
        placeHolder: String,
        accessibilityIdentifier: String? = nil
    ) {
        self.placeHolder = placeHolder
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

public class KUITextField: UITextField {
    public init(props: KUITextFieldProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent(props: KUITextFieldProps) {
        autocorrectionType = .no
        borderStyle = .roundedRect
        font = .systemFont(ofSize: 15)
        placeholder = props.placeHolder
        accessibilityIdentifier = props.accessibilityIdentifier
        translatesAutoresizingMaskIntoConstraints = false
    }

    // TODO: エラーの場合は枠線を赤色に更新できるようなメソッドを追加する
}
