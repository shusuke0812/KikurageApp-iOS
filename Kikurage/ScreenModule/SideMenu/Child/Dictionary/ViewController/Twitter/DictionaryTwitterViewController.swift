//
//  DictionaryTwitterViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DictionaryTwitterViewController: UIViewController {
    private var baseView: DictionaryTwitterBaseView { self.view as! DictionaryTwitterBaseView } // swiftlint:disable:this force_cast

    override func viewDidLoad() {
        super.viewDidLoad()

        baseView.configTableView(delegate: self, dataSource: self)
    }
}

// MARK: - UITableViewDelegate

extension DictionaryTwitterViewController: UITableViewDelegate {
}

// MARK: - UITableViewDataSource

extension DictionaryTwitterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
