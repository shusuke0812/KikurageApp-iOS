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
        self.viewModel = GraphViewModel(kikurageStateRepository: KikurageStateRepository())
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension GraphViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.viewModel.delegate = self
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
        <#code#>
    }
    func didFailedGetKikurageStateGraph(errorMessage: String) {
        <#code#>
    }
}
