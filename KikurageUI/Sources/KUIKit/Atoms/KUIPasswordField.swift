//
//  KUIPasswordField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIPasswordField: View {
    private var props: KUITextFieldProps

    public init(props: KUITextFieldProps) {
        self.props = props
    }

    public var body: some View {
        SecureField(props.placeHolder, text: props.$inputText)
            .modifier(KTextFieldModifier(hasError: props.$hasError))
    }
}
