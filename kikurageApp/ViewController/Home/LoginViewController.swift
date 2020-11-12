//
//  loginViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var productKeyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.setUI()
    }
    // MARK: - Action Method
    @IBAction func didTapStartButton(_ sender: Any) {
        // ホーム画面へ遷移する
        let s: UIStoryboard = UIStoryboard(name: "MainViewController", bundle: nil)
        let vc: UIViewController = s.instantiateViewController(withIdentifier: "MainViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func setUI() {
        // TODO：調整中
        // self.productKeyTextField.setTextFieldStyle(cornerRadius: 10, height: 60)
    }
}
