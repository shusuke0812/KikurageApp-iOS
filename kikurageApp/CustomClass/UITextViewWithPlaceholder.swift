//
//  UITextViewWithPlaceholder.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/17.
//  Copyright © 2020 shusuke. All rights reserved.
//

/*
 * UITextViewにコードでPlaceholderを設定できるようにするカスタムクラス
 */

import UIKit

class UITextViewWithPlaceholder: UITextView {
    /// プレースホルダーのラベル
    private lazy var placeholderLabel = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
    
    var placeholder: String = "" {
        didSet {
            if placeholder.isEmpty { return }
            self.placeholderLabel.text = NSLocalizedString(placeholder, comment: "")
            self.placeholderLabel.sizeToFit()
        }
    }
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setPlaceholder()
    }
}
// MARK: - Private Method
extension UITextViewWithPlaceholder {
    // TextViewの基本設定
    private func setPlaceholder() {
        self.placeholderLabel.backgroundColor = .clear
        self.placeholderLabel.textColor = UIColor.lightGray
        self.placeholderLabel.lineBreakMode = .byWordWrapping
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.font = self.font
        addSubview(self.placeholderLabel)
    }
    // Placeholderの表示・非表示切り替え
    internal func switchPlaceholderDisplay(text: String) {
        self.placeholderLabel.isHidden = text.isEmpty ? false : true
    }
}
