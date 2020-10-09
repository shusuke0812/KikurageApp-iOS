//
//  UIViewController+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UIViewController {
    /// ナビゲーションバー の体裁を設定する
    /// - Parameters:
    ///   - title: タイトル
    internal func setNavigationBar(title: String) {
        self.title = title
    }
}
