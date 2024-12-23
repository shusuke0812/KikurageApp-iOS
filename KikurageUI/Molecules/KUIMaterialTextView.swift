//
//  KUIMaterialTextView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/3.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIMaterialTextViewProps {
    let maxTextCount: Int
    let placeHolder: String?
    let backgroundColor: UIColor

    public init(maxTextCount: Int, placeHolder: String?, backgroundColor: UIColor) {
        self.maxTextCount = maxTextCount
        self.placeHolder = placeHolder
        self.backgroundColor = backgroundColor
    }
}

public class KUIMaterialTextView: UIView {
    public var onDidEndEditing: ((String) -> Void)?

    private var textView: UITextView!
    private var textViewPlaceHolderLabel: UILabel!
    private var dividerView: KUIDividerView!
    private var textCountLabel: KUITextCountLabel!

    private let maxTextCount: Int

    public init(props: KUIMaterialTextViewProps) {
        maxTextCount = props.maxTextCount

        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent(props: KUIMaterialTextViewProps) {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onTapDone))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 44)
        toolbar.setItems([flexSpaceItem, doneButtonItem], animated: true)

        textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = props.backgroundColor
        textView.inputAccessoryView = toolbar
        textView.font = .systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false

        textViewPlaceHolderLabel = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
        textViewPlaceHolderLabel.text = props.placeHolder
        textViewPlaceHolderLabel.backgroundColor = .clear
        textViewPlaceHolderLabel.font = .systemFont(ofSize: 15)
        textViewPlaceHolderLabel.textColor = UIColor.placeholderText
        textViewPlaceHolderLabel.lineBreakMode = .byWordWrapping
        textViewPlaceHolderLabel.numberOfLines = 0
        textViewPlaceHolderLabel.translatesAutoresizingMaskIntoConstraints = false

        dividerView = KUIDividerView(props: KUIDividerViewProps(color: .lightGray))
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        textCountLabel = KUITextCountLabel(props: KUITextCountLabelProps(
            textColor: .lightGray,
            maxCount: props.maxTextCount
        ))
        textCountLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textView)
        addSubview(textViewPlaceHolderLabel)
        addSubview(dividerView)
        addSubview(textCountLabel)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),

            dividerView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 3),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textCountLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 3),
            textCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func hidePlaceHolderLabel(text: String) {
        textViewPlaceHolderLabel.isHidden = text.isEmpty ? false : true
    }
}

// MARK: - UITextViewDelegate

extension KUIMaterialTextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let currentString = textView.text, let _range = Range(range, in: currentString) {
            let newString = currentString.replacingCharacters(in: _range, with: text)
            return newString.count <= maxTextCount
        } else {
            return false
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        textCountLabel.updateInputTextCount(text.count)
        hidePlaceHolderLabel(text: text)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        onDidEndEditing?(text)
    }

    @objc private func onTapDone() {
        textView.resignFirstResponder()
    }
}
