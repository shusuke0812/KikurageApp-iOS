//
//  UITextViewWithPlaceholder.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/17.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

/// UITextViewにコードでPlaceholderを設定できるようにするカスタムクラス
class UITextViewWithPlaceholder: UITextView {
    private var placeholderLabel = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
    /// プレースホルダー文字列
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = self.placeholder
            placeholderLabel.sizeToFit()
        }
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setPlaceholder()
    }
}

// MARK: - Config

extension UITextViewWithPlaceholder {
    private func setPlaceholder() {
        placeholderLabel.backgroundColor = .clear
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = font
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
    }

    func switchPlaceholderDisplay(text: String) {
        placeholderLabel.isHidden = text.isEmpty ? false : true
    }
}
