//
//  KUIPasswordField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

@available(*, deprecated, renamed: "KPasswordField", message: "Need to change to SiwftUI")
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

public struct KPasswordField: View {
    private var props: KTextFieldProps

    public init(props: KTextFieldProps) {
        self.props = props
    }

    public var body: some View {
        SecureField(props.placeHolder, text: props.$inputText)
            .modifier(KTextFieldModifier(hasError: props.$hasError))
    }
}
