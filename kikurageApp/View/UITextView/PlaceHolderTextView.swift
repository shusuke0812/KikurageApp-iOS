//
//  PlaceHolderTextView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/29.
//  Copyright © 2019 shusuke. All rights reserved.
//

import Foundation
import UIKit

public class PlaceHolderTextView: UITextView {
    private lazy var placeHolderLabel = UILabel()
    var placeHolderColor = UIColor.lightGray
    var placeHolder = ""

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextField.textDidChangeNotification, object: nil)
    }
    override public func draw(_ rect: CGRect) {
        if !self.placeHolder.isEmpty {
            self.placeHolderLabel.frame = CGRect(x: 8, y: 8, width: self.bounds.size.width - 16, height: 0)
            self.placeHolderLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.placeHolderLabel.numberOfLines = 0
            self.placeHolderLabel.font = self.font
            self.placeHolderLabel.backgroundColor = UIColor.clear
            self.placeHolderLabel.textColor = self.placeHolderColor
            self.placeHolderLabel.alpha = 0
            self.placeHolderLabel.tag = 1

            self.placeHolderLabel.text = self.placeHolder as String
            self.placeHolderLabel.sizeToFit()
            self.addSubview(placeHolderLabel)
        }
        self.sendSubviewToBack(placeHolderLabel)
        if self.text.utf16.isEmpty && !self.placeHolder.isEmpty {
            self.viewWithTag(1)?.alpha = 1
        }
        super.draw(rect)
    }
    @objc func textChanged(notification: NSNotification?) {
        if self.placeHolder.isEmpty {
            return
        }
        if self.text.utf16.isEmpty {
            self.viewWithTag(1)?.alpha = 1
        } else {
            self.viewWithTag(1)?.alpha = 0
        }
    }
}
