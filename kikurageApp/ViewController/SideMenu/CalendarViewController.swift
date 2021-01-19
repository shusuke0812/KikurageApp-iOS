//
//  CalendarViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    /// BaseView
    private var baseView: CalendarBaseView { self.view as! CalendarBaseView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension CalendarViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
    }
}
// MARK: - CalendarBaseView Delegate Method
extension CalendarViewController: CalendarBaseViewDelegate {
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
