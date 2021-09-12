//
//  GraphViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    /// BaseView
    private var baseView: GraphBaseView { self.view as! GraphBaseView } // swiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: GraphViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = GraphViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        self.setDelegateDataSource()
        self.loadKikurageUser()
    }
}
// MARK: - Initialized
extension GraphViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.viewModel.delegate = self
    }
    private func loadKikurageUser() {
        guard let userId = LoginHelper.shared.kikurageUserId else { return }
        self.viewModel.loadKikurageUser(uid: userId)
    }
    private func loadKikurageStateGraph() {
        guard let kikurageUser = self.viewModel.kikurageUser else { return }
        self.viewModel.loadKikurageStateGraph(productId: kikurageUser.productKey)
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
        self.baseView.setLineChartView(datas: self.viewModel.humidityGraphDatas, graphDataType: .humidity)
        self.baseView.setLineChartView(datas: self.viewModel.temperatureGraphDatas, graphDataType: .temperature)
    }
    func didFailedGetKikurageStateGraph(errorMessage: String) {
        print(errorMessage)
    }
    func didSuccessGetKikurageUser() {
        self.loadKikurageStateGraph()
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        print(errorMessage)
    }
}
