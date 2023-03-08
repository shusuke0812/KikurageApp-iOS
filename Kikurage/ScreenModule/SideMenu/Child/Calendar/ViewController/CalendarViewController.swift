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
        setNavigation()

        if let userId = LoginHelper.shared.kikurageUserId {
            viewModel.loadKikurageUser(uid: userId)
        }
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension CalendarViewController {
    private func setDelegateDataSource() {
        viewModel.delegate = self
    }
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.side_menu_clendar_title()
    }
}

// MARK: - CalendarViewModel Delegate

extension CalendarViewController: CalendarViewModelDelegate {
    func calendarViewModelDidSuccessGetKikurageUser(_ calendarViewModel: CalendarViewModel) {
        baseView.initCalendarView(cultivationStartDateComponents: calendarViewModel.cultivationDateComponents, cultivationTerm: (calendarViewModel.cultivationTerm ?? 0))
    }
    func calendarViewModelDidFailedGetKikurageUser(_ calendarViewModel: CalendarViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
}
