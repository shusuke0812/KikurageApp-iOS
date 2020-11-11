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
    
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var calendarView: SideMenuContentView!
    @IBOutlet weak var graphView: SideMenuContentView!
    @IBOutlet weak var contactView: SideMenuContentView!
    @IBOutlet weak var settingView: SideMenuContentView!
    @IBOutlet weak var licenseView: SideMenuContentView!
    @IBOutlet weak var searchRecipeView: SideMenuContentView!
    @IBOutlet weak var kikurageDictionaryView: SideMenuContentView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setAnimation()
    }
    
    // MARK: - Action Method
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.sideMenuView.layer.position.x = -self.sideMenuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    // 問い合わせタップ
    @IBAction func didTapContactContent(_ sender: Any) {
        self.openContactMailer()
    }
}

// MARK: - Initialized Method
extension SideMenuViewController {
    private func setUI() {
        // サイドメニュー項目設定
        self.setSideMenuContent(view: self.calendarView, title: "カレンダー", imageSystemName: "calendar")
        self.setSideMenuContent(view: self.graphView, title: "グラフ", imageSystemName: "waveform.path.ecg")
        self.setSideMenuContent(view: self.contactView, title: "問い合わせ", imageSystemName: "questionmark.circle")
        self.setSideMenuContent(view: self.settingView, title: "設定", imageSystemName: "gearshape")
        self.setSideMenuContent(view: self.licenseView, title: "著作権", imageSystemName: "info.circle")
        self.setSideMenuContent(view: self.searchRecipeView, title: "料理レシピ検索", imageSystemName: "magnifyingglass")
        self.setSideMenuContent(view: self.kikurageDictionaryView, title: "きくらげ豆知識", imageSystemName: "doc.text")
    }
    private func setSideMenuContent(view: SideMenuContentView, title: String, imageSystemName: String) {
        view.sideMenuContentLabel.text = title
        view.sideMenuContentIconView.image = UIImage(systemName: imageSystemName)
    }
    private func setAnimation() {
        // メニューの位置を取得する
        let menuPosition: CGPoint = self.sideMenuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.sideMenuView.layer.position.x = -self.sideMenuView.frame.width
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.sideMenuView.layer.position.x = menuPosition.x
        },
            completion: { bool in
        })
    }
}
// MARK: - MFMail Delegate Method
extension SideMenuViewController: MFMailComposeViewControllerDelegate {
    // 問い合わせのメーラーを開く
    private func openContactMailer() {
        if MFMailComposeViewController.canSendMail() {
            let mail: MFMailComposeViewController = MFMailComposeViewController()
            
            mail.mailComposeDelegate = self
            // 宛先のメールアドレス
            mail.setToRecipients(["kikurageproject2019@googlegroups.com"])
            // 件名
            mail.setSubject("【きくらげ君アプリ】お問い合わせ")
            // 本文
            mail.setMessageBody("質問を入力して送信ボタンを押して下さい。\n--------------", isHTML: false)
            self.present(mail, animated: true, completion: nil)
        } else {
            print("送信できません")
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書き保存")
        case .sent:
            print("送信成功")
        default:
            print("送信失敗")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
