//
//  PostCultivationViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class PostCultivationViewController: UIViewController {
    /// BaseView
    private var baseView: PostCultivationBaseView { self.view as! PostCultivationBaseView}
    /// ViewModel
    private var viewModel: PostCultivationViewModel!
    /// きくらげユーザーID
    var kikurageUserId: String?
    /// 栽培記録
    var cultivation: KikurageCultivation?
    
    private let dateHelper: DateHelper = DateHelper()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PostCultivationViewModel(cultivationRepository: CultivationRepository())
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension PostCultivationViewController {
    private func initUI() {
        
    }
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.dateTextField.delegate = self
    }
}

// MARK: - Dekegate Method
extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func didTapPostButton() {
    }
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension PostCultivationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateString = dateHelper.formatToString(date: self.baseView.datePicker.date)
        self.baseView.dateTextField.text = dateString
        //self.cultivation?.viewDate = dateString
    }
}
