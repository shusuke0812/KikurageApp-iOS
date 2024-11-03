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
    
    public init(maxTextCount: Int, placeHolder: String?) {
        self.maxTextCount = maxTextCount
        self.placeHolder = placeHolder
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponent(props: KUIMaterialTextFieldProps) {
        textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .none
        textField.clearButtonMode = .never
        textField.placeholder = props.placeHolder
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
        var resultText = ""
        if let text = textField.text {
            resultText = (text as NSString).replacingCharacters(in: range, with: text)
        }
        return resultText.count <= maxTextCount
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
}
