//
//  MenuViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/29.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import MessageUI

class SideMenuViewController: UIViewController {
    private var baseView: SideMenuBaseView { self.view as! SideMenuBaseView } // swiftlint:disable:this force_cast

    private let mail = MFMailComposeViewController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAnimation()
    }
    // MARK: - Action
    // メニューエリア以外をタップした時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches where touch.view == baseView {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseIn,
                animations: { self.baseView.sideMenuParentView.layer.position.x = -(self.baseView.sideMenuParentView.frame.width) }
            ) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
// MARK: - Initialized
extension SideMenuViewController {
    private func setAnimation() {
        // メニューの位置を取得する
        let menuPosition: CGPoint = baseView.sideMenuParentView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        baseView.sideMenuParentView.layer.position.x = -(baseView.sideMenuParentView.frame.width)
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: { self.baseView.sideMenuParentView.layer.position.x = menuPosition.x },
            completion: nil
        )
    }
    private func setDelegateDataSource() {
        baseView.delegate = self
        mail.mailComposeDelegate = self
    }
}
// MARK: - MFMail Delegate
extension SideMenuViewController: MFMailComposeViewControllerDelegate {
    private func openContactMailer() {
        if MFMailComposeViewController.canSendMail() {
            // 宛先のメールアドレス
            mail.setToRecipients(["kikurageproject2019@googlegroups.com"])
            // 件名
            mail.setSubject("【きくらげ君アプリ】お問い合わせ")
            // 本文
            mail.setMessageBody("質問を入力して送信ボタンを押して下さい。\n--------------", isHTML: false)
            present(mail, animated: true, completion: nil)
        } else {
            print("DEBUG: 送信できません")
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("DEBUG: キャンセル")
        case .saved:
            print("DEBUG: 下書き保存")
        case .sent:
            print("DEBUG: 送信成功")
        default:
            print("DEBUG: 送信失敗")
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
// MARK: - SideMenuBaaseView Delegate
extension SideMenuViewController: SideMenuBaseViewDelegate {
    func didTapContactCell() {
        openContactMailer()
    }
    func didTapGraphCell() {
        guard let vc = R.storyboard.graphViewController.instantiateInitialViewController() else { return }
        present(vc, animated: true, completion: nil)
    }
    func didTapCalendarCell() {
        guard let vc = R.storyboard.calendarViewController.instantiateInitialViewController() else { return }
        present(vc, animated: true, completion: nil)
    }
}
