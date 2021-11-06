//
//  GraphViewController.swift
//  kikurageApp
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
        viewModel.loadKikurageUser(uid: userId)
    }
    private func loadKikurageStateGraph() {
        guard let kikurageUser = viewModel.kikurageUser else { return }
        viewModel.loadKikurageStateGraph(productId: kikurageUser.productKey)
    }
}
// MARK: - GraphBaseView Delegate
extension GraphViewController: GraphBaseViewDelegate {
    func didTapCloseButton() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
// MARK: - GraphViewModel Delegate
extension GraphViewController: GraphViewModelDelegate {
    func didSuccessGetKikurageStateGraph() {
        baseView.setLineChartView(datas: viewModel.humidityGraphDatas, graphDataType: .humidity)
        baseView.setLineChartView(datas: viewModel.temperatureGraphDatas, graphDataType: .temperature)
    }
    func didFailedGetKikurageStateGraph(errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
    func didSuccessGetKikurageUser() {
        loadKikurageStateGraph()
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
}
