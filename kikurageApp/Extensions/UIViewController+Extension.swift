//
//  UIViewController+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    /// ナビゲーションバー の体裁を設定する
    /// - Parameters:
    ///   - title: タイトル
    internal func setNavigationBar(title: String) {
        self.title = title
    }
    /// Safariで指定したURLのページを開く
    /// - Parameters:
    ///   - urlString: URL
    internal func transitionSafariViewController(urlString: String) {
        let url: URL?
        // 不正なURLであるかを判定する
        //（不正なものはhttpsプレフィックスをつけてブラウザでエラーハンドリングする）
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https") {
            url = URL(string: urlString)
        } else {
            url = URL(string: "https://" + urlString)
        }
        // Safariで引数URLのページを開く
        if let url = url {
            let safariVC: SFSafariViewController = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
}
