//
//  CalendarViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KAAnalytics
import UIKit

class CalendarViewController: UIViewController, UIViewControllerNavigatable {
    private var viewModel: CalendarViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CalendarViewModel()
        viewModel.delegate = self
        setNavigation()

        let baseView = CalendarBaseView(state: viewModel.state)
        let _ = addBaseView(baseView: baseView)

        viewModel.loadKikurageUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.calendar)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension CalendarViewController {
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.side_menu_clendar_title()
    }
}

// MARK: - CalendarViewModel Delegate

extension CalendarViewController: CalendarViewModelDelegate {
    func calendarViewModelDidSuccessGetKikurageUser(_ calendarViewModel: CalendarViewModel) {}

    func calendarViewModelDidFailedGetKikurageUser(_ calendarViewModel: CalendarViewModel, with errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.errorMessage = errorMessage
            self?.viewModel.state.hasError = true
        }
    }
}
