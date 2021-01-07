//
//  LoginBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol LoginBaseViewDelegate: class {
    /// ログインボタンを押した時の処理
    func didTapLoginButton()
    /// 利用規約ボタンを押した時の処理
    func didTapTermsButton()
    /// 個人情報保護方針ボタンを押した時の処理
    func didTapPrivacyPolicyButton()
}

class LoginBaseView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productKeyTextField: UITextField!
    @IBOutlet weak var kikurageNameTextField: UITextField!
    @IBOutlet weak var cultivationStartDateTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var copyRightLabel: UILabel!
    /// デリゲート
    internal weak var delegate: LoginBaseViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    // MARK: - Action Method
    @IBAction func didTapLoginButton(_ sender: Any) {
        self.delegate?.didTapLoginButton()
    }
    @IBAction func didTapTermsButton(_ sender: Any) {
        self.delegate?.didTapTermsButton()
    }
    @IBAction func didTapPrivacyPolicyButton(_ sender: Any) {
        self.delegate?.didTapPrivacyPolicyButton()
    }
}
// MARK: - Initialized Method
extension LoginBaseView {
    private func initUI() {
        // 画像
        self.imageView.image = UIImage(named: "kikurageDevice")
        // ログインボタンの体裁
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 5
        // コピーライト
        self.copyRightLabel.text = "©︎ チーム きくらげ大使館"
    }
}
