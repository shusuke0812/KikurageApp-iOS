//
//  UIView+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UIView {
    /// 任意の箇所に枠線をつける
    /// - Parameters:
    ///   - width: 枠線の幅
    ///   - color: 枠線の色
    ///   - position: 枠線をつける場所
    func setFrameBoarder(width: CGFloat, color: UIColor, position: BoarderPosition) {
        let boarder = CALayer()

        switch position {
        case .top:
            boarder.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
            boarder.backgroundColor = color.cgColor
            self.layer.addSublayer(boarder)
        case .bottom:
            boarder.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
            boarder.backgroundColor = color.cgColor
            self.layer.addSublayer(boarder)
        case .trailing:
            boarder.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
            boarder.backgroundColor = color.cgColor
            self.layer.addSublayer(boarder)
        case .leading:
            boarder.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.width)
            boarder.backgroundColor = color.cgColor
            self.layer.addSublayer(boarder)
        }
    }
    enum BoarderPosition {
        case top
        case bottom
        case trailing
        case leading
    }
}
