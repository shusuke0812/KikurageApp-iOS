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
    
    public init(maxTextCount: Int, placeHolder: String?) {
        self.maxTextCount = maxTextCount
        self.placeHolder = placeHolder
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
        textView = UITextView()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textViewPlaceHolderLabel = UILabel(frame:  CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
        textViewPlaceHolderLabel.backgroundColor = .clear
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
        var resultText = ""
        if let text = textView.text {
            resultText = (text as NSString).replacingCharacters(in: range, with: text)
        }
        return resultText.count <= maxTextCount
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
}
