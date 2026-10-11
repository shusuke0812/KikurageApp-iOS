//
//  SideMenuViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/29.
//  Copyright © 2019 shusuke. All rights reserved.
//

import MessageUI
import SwiftUI
import UIKit

class SideMenuViewController: UIViewController, UIViewControllerNavigatable, SideMenuAccessable {
    private var viewModel: SideMenuViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SideMenuViewModel()

        let baseView = SideMenuBaseView(sections: viewModel.sections, delegate: self)
        let hostingController = addBaseView(baseView: baseView)
        hostingController.view.backgroundColor = .clear
    }

}

// MARK: - MFMail Delegate

extension SideMenuViewController: MFMailComposeViewControllerDelegate {
    private func openContactMailer() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            // 宛先のメールアドレス
            mail.setToRecipients([Constants.Email.address])
            // 件名
            mail.setSubject(R.string.localizable.side_menu_mail_subject())
            // 本文
            mail.setMessageBody(R.string.localizable.side_menu_mail_message_body(), isHTML: false)
            present(mail, animated: true, completion: nil)
        } else {
            UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.common_error(), message: R.string.localizable.side_menu_mail_error(), okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            break
        default:
            break
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Search Recipe

extension SideMenuViewController {
    private func openSearchRecipePage() {
        let query = (R.string.localizable.side_menu_search_recipe_word()).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "https://cookpad.com/search/\(query)"
        presentSafariView(urlString: urlString, onError: {
            UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.common_error(), message: R.string.localizable.side_menu_search_recipe_error(), okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        })
    }
}

// MARK: - SideMenuBaseView Delegate

extension SideMenuViewController: SideMenuBaseViewDelegate {
    func sideMenuBaseViewDidSelectItem(_ item: SideMenuViewModel.SectionRowType) {
        switch item {
        case .calendar:
            modalToCalendar { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        case .graph:
            modalToGraph { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        case .contact:
            openContactMailer()
        case .accountSetting:
            modalToAccountSetting { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        case .license:
            AcknowledgementControlller.openSettingApp(onError: {
                UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.common_error(), message: R.string.localizable.side_menu_license_error(), okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
            })
        case .searchRecipe:
            openSearchRecipePage()
        case .kikurageDictionary:
            modalToDictionary { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        case .wifi:
            modalToWiFi { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        case .debugTry:
            modalToDebug { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func sideMenuBaseViewDidRequestClose() {
        dismiss(animated: true, completion: nil)
    }
}
