//
//  KUIPasswordField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public class KUIPasswordField: KUITextField {
    override public init(props: KUITextFieldProps) {
        super.init(props: props)
        setupComponent()
    }

    public required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        isSecureTextEntry = true
    }
}
