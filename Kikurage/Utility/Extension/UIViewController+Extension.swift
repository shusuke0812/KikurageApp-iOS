//
//  UIViewController+Extension.swift
//  Kikurage
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
    ///   - onError: エラー時のハンドリング
    func transitionSafariViewController(urlString: String?, onError: (() -> Void)?)
    /// ImagePicker起動
    func openImagePicker()
    ///  iOS15対策：NavigationBarの背景色を設定（iOS15、NavBar背景色が透明になる）
    func adjustNavigationBarBackgroundColor()
}

extension UIViewControllerNavigatable where Self: UIViewController {
    func setNavigationBar(title: String) {
        self.title = title
    }
    func setNavigationBackButton(buttonTitle: String, buttonColor: UIColor) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = buttonColor
    }
    func transitionSafariViewController(urlString: String?, onError: (() -> Void)?) {
        let url: URL?
        guard let urlString = urlString else { onError?(); return }
        // 不正なURLであるかを判定する（不正なものはhttpsプレフィックスをつけてブラウザでエラーハンドリングする）
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https") {
            url = URL(string: urlString)
        } else {
            url = URL(string: "https://" + urlString)
        }

        if let url = url {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        } else {
            onError?()
        }
    }
    func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func adjustNavigationBarBackgroundColor() {
        guard let nc = self.navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGroupedBackground
        nc.navigationBar.standardAppearance = appearance
        nc.navigationBar.scrollEdgeAppearance = nc.navigationBar.standardAppearance
    }
}
