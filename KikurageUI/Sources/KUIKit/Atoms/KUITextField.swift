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
}

public class KTextFieldProps {
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
            .autocorrectionDisabled()
            .overlay(
                RoundedRectangle(cornerRadius: 1)
                    .stroke(props.hasError ? Color.red : Color.gray, lineWidth: 1)
            )
    }
}
