//
//  KUITextField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUITextFieldProps {
    public let placeHolder: String
    @Binding public var inputText: String
    @Binding public var hasError: Bool

    public init(
        placeHolder: String,
        inputText: Binding<String> = .constant(""),
        hasError: Binding<Bool> = .constant(false)
    ) {
        self.placeHolder = placeHolder
        _inputText = inputText
        _hasError = hasError
    }
}

public struct KUITextField: View {
    private var props: KUITextFieldProps

    public init(props: KUITextFieldProps) {
        self.props = props
    }

    public var body: some View {
        TextField(props.placeHolder, text: props.$inputText)
            .modifier(KTextFieldModifier(hasError: props.$hasError))
    }
}

struct KTextFieldModifier: ViewModifier {
    @Binding var hasError: Bool

    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 44)
            .autocorrectionDisabled()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(hasError ? Color.red : Color.gray, lineWidth: 0.5)
            )
    }
}
