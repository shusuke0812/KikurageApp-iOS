//
//  UIColor+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UIColor {
    /// テーマカラー
    internal static var themeColor: UIColor {
        UIColor(named: "themeColor")! // swiftlint:disable:this force_unwrapping
    }
    /// サブカラー
    internal static var subColor: UIColor {
        UIColor(named: "subColor")! // swiftlint:disable:this force_unwrapping
    }
    /// お知らせカラー
    internal static var information: UIColor {
        UIColor(named: "informationColor")! // swiftlint:disable:this force_unwrapping
    }
}
