//
//  loginViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/22.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    /// BaseView
    private var baseView: LoginBaseView { self.view as! LoginBaseView }
    /// ViewModel
    private var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegateDataSource()
        self.viewModel = LoginViewModel(kikurageStateRepository: KikurageStateRepository(),
                                        kikurageUserRepository: KikurageUserRepository())
    }
}
// MARK: - Initialized Method
extension LoginViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - LoginBaseView Delegate Method
extension LoginViewController: LoginBaseViewDelegate {
    func didTapLoginButton() {
        self.transitionHomePage()
    }
    private func transitionHomePage() {
        let s = UIStoryboard(name: "MainViewController", bundle: nil)
        let vc = s.instantiateInitialViewController() as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    func didTapTermsButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.terms)
    }
    func didTapPrivacyPolicyButton() {
        self.transitionSafariViewController(urlString: Constants.WebUrl.privacyPolicy)
    }
}
// MARK: - LoginViewModel Delegate Method
extension LoginViewController: LoginViewModelDelegate {
    func didSuccessGetKikurageState() {
        <#code#>
    }
    func didFailedGetKikurageState(errorMessage: String) {
        <#code#>
    }
    func didSuccessGetKikurageUser() {
        <#code#>
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        <#code#>
    }
}
