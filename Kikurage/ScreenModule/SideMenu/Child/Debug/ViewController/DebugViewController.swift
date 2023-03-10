//
//  DebugViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {
    private var baseView: DebugBaseView { view as! DebugBaseView } // sswiftlint:disable:this force_cast
    private var viewModel: DebugViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.delegate = self
        viewModel = DebugViewModel()
    }
}

// MARK: - DebugBaseView Delegate

extension DebugViewController: DebugBaseViewDelegate {
    func debugBaseViewDidTappedForceRestrart(_ debugBaseView: DebugBaseView) {
        LoginHelper.shared.logout()
    }
}
