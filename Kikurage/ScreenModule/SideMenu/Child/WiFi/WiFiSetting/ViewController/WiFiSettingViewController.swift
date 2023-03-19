//
//  WiFiSettingViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiSettingViewController: UIViewController {
    private let viewModel: WiFiSettingViewModel

    init(selectedSSID: String) {
        viewModel = WiFiSettingViewModel(selectedSSID: selectedSSID)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
