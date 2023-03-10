//
//  UIColor+Extension.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UIColor {
    /// テーマカラー
    static var themeColor: UIColor {
        UIColor(named: "themeColor")! // swiftlint:disable:this force_unwrapping
    }

    /// サブカラー
    static var subColor: UIColor {
        UIColor(named: "subColor")! // swiftlint:disable:this force_unwrapping
    }

    /// お知らせカラー
    static var information: UIColor {
        UIColor(named: "informationColor")! // swiftlint:disable:this force_unwrapping
    }

    /// HEX（16進数）で色を設定する
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let value = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(value / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(value / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(value / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}
