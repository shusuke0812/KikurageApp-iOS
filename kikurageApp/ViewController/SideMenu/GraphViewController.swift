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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension GraphViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
    }
}
// MARK: - GraphBaseView Delegate Method
extension GraphViewController: GraphBaseViewDelegate {
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
