//
//  KUIMaterialTextField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/3.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIMaterialTextFieldProps {
    let maxTextCount: Int
    let placeHolder: String?
    let alignment: NSTextAlignment
    let fontSize: CGFloat

    public init(
        maxTextCount: Int,
        placeHolder: String? = nil,
        alignment: NSTextAlignment = .left,
        fontSize: CGFloat = 15
    ) {
        self.maxTextCount = maxTextCount
        self.placeHolder = placeHolder
        self.alignment = alignment
        self.fontSize = fontSize
    }
}

public class KUIMaterialTextField: UIView {
    public var onDidEndEditing: ((String) -> Void)?

    private var textField: UITextField!
    private var dividerView: KUIDividerView!
    private var textCountLabel: KUITextCountLabel!

    private let maxTextCount: Int

    public init(props: KUIMaterialTextFieldProps) {
        maxTextCount = props.maxTextCount

        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupText(_ value: String) {
        textField.text = value
    }

    private func setupComponent(props: KUIMaterialTextFieldProps) {
        textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .none
        textField.clearButtonMode = .never
        textField.placeholder = props.placeHolder
        textField.font = .systemFont(ofSize: props.fontSize)
        textField.textAlignment = props.alignment
        textField.translatesAutoresizingMaskIntoConstraints = false

        dividerView = KUIDividerView(props: KUIDividerViewProps(color: .lightGray))
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        textCountLabel = KUITextCountLabel(props: KUITextCountLabelProps(
            textColor: .lightGray,
            maxCount: props.maxTextCount
        ))
        textCountLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textField)
        addSubview(dividerView)
        addSubview(textCountLabel)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),

            dividerView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textCountLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 3),
            textCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension KUIMaterialTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentString = textField.text, let _range = Range(range, in: currentString) {
            let newString = currentString.replacingCharacters(in: _range, with: string)
            return newString.count <= maxTextCount
        } else {
            return false
        }
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        textCountLabel.updateInputTextCount(text.count)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        onDidEndEditing?(text)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
