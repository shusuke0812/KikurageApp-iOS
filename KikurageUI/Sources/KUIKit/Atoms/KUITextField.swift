//
//  KUITextField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUITextFieldProps {
    let placeHolder: String

    public init(placeHolder: String) {
        self.placeHolder = placeHolder
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
        translatesAutoresizingMaskIntoConstraints = false
    }
}

public struct KTextFieldProps {
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

public struct KTextField: View {
    private var props: KTextFieldProps

    public init(props: KTextFieldProps) {
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
