//
//  UIAlertController+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/7.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UIAlertController {
    internal static func showAlert(style: UIAlertController.Style, viewController: UIViewController,
                                   title: String?, message: String?, okButtonTitle: String, cancelButtonTitle: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { (action: UIAlertAction!) -> Void in
            print("DEBUG: アラートのOKボタンが押されました")
        })
        alert.addAction(okAction)
        if let cancelButtonTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .default, handler: { (action: UIAlertAction) -> Void in
                print("DEBUG: アラートのキャンセルボタンが押されました")
            })
            alert.addAction(cancelAction)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
