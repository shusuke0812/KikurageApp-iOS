//
//  GraphViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    private var baseView: GraphBaseView { self.view as! GraphBaseView } // swiftlint:disable:this force_cast
    private var viewModel: GraphViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GraphViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        setDelegateDataSource()
        loadKikurageUser()
    }
}

// MARK: - Initialized

extension GraphViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        viewModel.delegate = self
    }
    private func loadKikurageUser() {
        guard let userId = LoginHelper.shared.kikurageUserId else { return }
        baseView.startGraphActivityIndicators()
        viewModel.loadKikurageUser(uid: userId)
    }
    private func loadKikurageStateGraph() {
        guard let kikurageUser = viewModel.kikurageUser else { return }
        viewModel.loadKikurageStateGraph(productId: kikurageUser.productKey)
    }
}

// MARK: - GraphBaseView Delegate

extension GraphViewController: GraphBaseViewDelegate {
    func graphBaseViewDidTapCloseButton() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - GraphViewModel Delegate

extension GraphViewController: GraphViewModelDelegate {
    func graphViewModelDidSuccessGetKikurageStateGraph(_ graphViewModel: GraphViewModel) {
        DispatchQueue.main.async {
            self.baseView.stopGraphActivityIndicators()

            self.baseView.setLineChartView(datas: graphViewModel.humidityGraphDatas, graphDataType: .humidity)
            self.baseView.setLineChartView(datas: graphViewModel.temperatureGraphDatas, graphDataType: .temperature)
        }
    }
    func graphViewModelDidFailedGetKikurageStateGraph(_ graphViewModel: GraphViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.baseView.stopGraphActivityIndicators()

            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
    func graphViewModelDidSuccessGetKikurageUser(_ graphViewModel: GraphViewModel) {
        loadKikurageStateGraph()
    }
    func graphViewModelDidFailedGetKikurageUser(_ graphViewModel: GraphViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
}
