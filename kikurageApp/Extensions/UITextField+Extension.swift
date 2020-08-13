//
//  UITextField+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/8/13.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UITextField {
    /// テキストフィールドの体裁を設定するメソッド
    /// - Parameters:
    ///   - cornerRadius: 角丸
    ///   - height: 高さ
    func setTextFieldStyle(cornerRadius: Int, height: Int) {
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.frame.size.height = CGFloat(height)
    }
}
