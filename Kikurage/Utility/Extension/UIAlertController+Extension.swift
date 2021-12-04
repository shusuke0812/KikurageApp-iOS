//
//  UIAlertController+Extension.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/7.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlert(style: UIAlertController.Style, viewController: UIViewController, title: String?, message: String?, okButtonTitle: String, cancelButtonTitle: String?, completionOk: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        // キャンセル｜OK というボタン配置にするためにCancelActionを先にAddする
        if let cancelButtonTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ -> Void in
                print("DEBUG: アラートのキャンセルボタンが押されました")
            }
            alert.addAction(cancelAction)
        }
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ -> Void in
            print("DEBUG: アラートのOKボタンが押されました")
            if let completionOk = completionOk {
                completionOk()
            }
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
