//
//  GraphViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KAAnalytics
import KSGraphService
import UIKit

class GraphViewController: UIViewController, UIViewControllerNavigatable {
    private var viewModel: GraphViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GraphViewModel()
        viewModel.delegate = self
        setNavigation()

        let baseView = GraphBaseView(state: viewModel.state)
        let _ = addBaseView(baseView: baseView)

        loadKikurageUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.graph)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension GraphViewController {
    private func setNavigation() {
        let closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeBarButtonItem]
        navigationItem.title = R.string.localizable.side_menu_graph_title()
    }

    private func loadKikurageUser() {
        viewModel.state.isLoading = true
        viewModel.loadKikurageUser()
    }

    private func loadKikurageStateGraph() {
        viewModel.loadKikurageStateGraph()
    }
}

// MARK: - GraphViewModel Delegate

extension GraphViewController: GraphViewModelDelegate {
    func graphViewModelDidSuccessGetKikurageStateGraph(_ graphViewModel: GraphViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.isLoading = false
        }
    }

    func graphViewModelDidFailedGetKikurageStateGraph(_ graphViewModel: GraphViewModel, with errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.isLoading = false
            self?.viewModel.state.errorMessage = errorMessage
            self?.viewModel.state.hasError = true
        }
    }

    func graphViewModelDidSuccessGetKikurageUser(_ graphViewModel: GraphViewModel) {
        loadKikurageStateGraph()
    }

    func graphViewModelDidFailedGetKikurageUser(_ graphViewModel: GraphViewModel, with errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.isLoading = false
            self?.viewModel.state.errorMessage = errorMessage
            self?.viewModel.state.hasError = true
        }
    }
}
