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
    private var baseView: GraphBaseView { self.view as! GraphBaseView }
    /// ViewModel
    private var viewModel: GraphViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = GraphViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUserRepository: KikurageUserRepository())
        self.setDelegateDataSource()
        self.loadKikurageUser()
    }
}
// MARK: - Initialized Method
extension GraphViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.viewModel.delegate = self
    }
    private func loadKikurageUser() {
        guard let userId = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userId) else { return }
        self.viewModel.loadKikurageUser(uid: userId)
    }
    private func loadKikurageStateGraph() {
        guard let kikurageUser = self.viewModel.kikurageUser else { return }
        self.viewModel.loadKikurageStateGraph(productId: kikurageUser.productKey)
    }
}
// MARK: - GraphBaseView Delegate Method
extension GraphViewController: GraphBaseViewDelegate {
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - GraphViewModel Delegate Method
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
