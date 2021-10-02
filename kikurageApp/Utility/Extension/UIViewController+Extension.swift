//
//  UIViewController+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import SafariServices

// MEMO: UIViewControllerにExtensionすると将来的にメソッド名が衝突する可能性があるため、独自プロトコルに定義し、そのプロトコルのExtensionで拡張する方針
protocol UIViewControllerNavigatable {
    /// ナビゲーションバー の体裁を設定する
    /// - Parameters:
    ///   - title: タイトル
    func setNavigationBar(title: String)
    /// ナビゲーションrootの遷移先に表示する戻るボタンの設定
    /// - Parameters:
    ///   - buttonTitle: 戻るボタン名（例：戻る、空文字""）
    ///   - buttonColor: 戻るボタン色
    func setNavigationBackButton(buttonTitle: String, buttonColor: UIColor)
    /// Safariで指定したURLのページを開く
    /// - Parameters:
    ///   - urlString: URL
    func transitionSafariViewController(urlString: String)
    /// ImagePicker起動
    func openImagePicker()
}

extension UIViewControllerNavigatable where Self: UIViewController {
    func setNavigationBar(title: String) {
        self.title = title
    }
    func setNavigationBackButton(buttonTitle: String, buttonColor: UIColor) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = buttonColor
    }
    func transitionSafariViewController(urlString: String) {
        let url: URL?
        // TODO: Stringの引数ではなく、URL型を渡す
        // 不正なURLであるかを判定する
        // （不正なものはhttpsプレフィックスをつけてブラウザでエラーハンドリングする）
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https") {
            url = URL(string: urlString)
        } else {
            url = URL(string: "https://" + urlString)
        }
        // Safariで引数URLのページを開く
        if let url = url {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
}
