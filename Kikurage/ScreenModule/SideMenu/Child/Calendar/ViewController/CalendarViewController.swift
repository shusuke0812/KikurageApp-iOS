//
//  CalendarViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    private var baseView: CalendarBaseView { self.view as! CalendarBaseView } // sswiftlint:disable:this force_cast
    private var viewModel: CalendarViewModel!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CalendarViewModel(kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()
    }
}

// MARK: - Initialized

extension CalendarViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
    }
}

// MARK: - CalendarBaseView Delegate

extension CalendarViewController: CalendarBaseViewDelegate {
    func didTapCloseButton() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CalendarViewModel Delegate

extension CalendarViewController: CalendarViewModelDelegate {
    func didSuccessGetKikurageUser() {
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
}
