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
        return UIColor(named: "themeColor")!
    }
    /// サブカラー
    internal static var subColor: UIColor {
        return UIColor(named: "subColor")!
    }
}
