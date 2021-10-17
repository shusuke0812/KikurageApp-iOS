//
//  CalendarViewController.swift
//  kikurageApp
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
        self.viewModel = CalendarViewModel(kikurageUserRepository: KikurageUserRepository())
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized
extension CalendarViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
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
        print(errorMessage)
    }
}
