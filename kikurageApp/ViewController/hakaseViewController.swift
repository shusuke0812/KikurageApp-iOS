//
//  hakaseViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

import MessageUI //Mailer追加
import SafariServices //Webアクセス

class hakaseViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
/*facebookグループ：https://www.facebook.com/groups/kikurage.community.2019/ */

//====================================================
/***********  Facebookグループへアクセス  ***********/
//====================================================
 
    @IBAction func communityButton(_ sender: Any) {
        guard let url = URL(string: "https://www.facebook.com/groups/kikurage.community.2019/") else { return }
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
    }
 
    
//====================================================
/***********  「問い合せボタン」からメールを送る  ***********/
//====================================================
    
//【課題①】iPhoneに保存されている写真を添付してメール機能　未実施　どうするか？
    
    @IBAction func sendEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            mail.mailComposeDelegate = self
            mail.setToRecipients(["kikurageproject2019@googlegroups.com"]) // 宛先アドレスMain
//          mail.setToRecipients(["shu.ota0812@gmail.com"]) // 宛先アドレスTest
            mail.setSubject("【きくらげ君アプリ】お問い合わせ") // 件名
            mail.setMessageBody("質問を入力して送信ボタンを押して下さい。\n--------------", isHTML: false) // 本文
            
            present(mail, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
