//
//  UITextViewWithPlaceholder.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/17.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

/// UITextViewにコードでPlaceholderを設定できるようにするカスタムクラス
class UITextViewWithPlaceholder: UITextView {
    private lazy var placeholderLabel = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
    /// プレースホルダー文字列
    var placeholder: String = "" {
        didSet {
            if placeholder.isEmpty { return }
            self.placeholderLabel.text = self.placeholder
            self.placeholderLabel.sizeToFit()
        }
    }
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setPlaceholder()
    }
}
// MARK: - Config
extension UITextViewWithPlaceholder {
    private func setPlaceholder() {
        self.placeholderLabel.backgroundColor = .clear
        self.placeholderLabel.textColor = UIColor.lightGray
        self.placeholderLabel.lineBreakMode = .byWordWrapping
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.font = self.font
        addSubview(self.placeholderLabel)
    }
    func switchPlaceholderDisplay(text: String) {
        self.placeholderLabel.isHidden = text.isEmpty ? false : true
    }
}
