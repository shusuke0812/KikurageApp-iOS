//
//  UIAlertController+Extension.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/7.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

extension UIAlertController {
    static func showAlert(
        style: UIAlertController.Style, viewController: UIViewController, title: String?, message: String?, okButtonTitle: String, cancelButtonTitle: String?, completionOk: (() -> Void)?, logMessage: String = ""
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        // キャンセル｜OK というボタン配置にするためにCancelActionを先にAddする
        if let cancelButtonTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
                KLogManager.debug(logMessage)
            }
            alert.addAction(cancelAction)
        }
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            KLogManager.debug(logMessage)
            if let completionOk = completionOk {
                completionOk()
            }
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
