//
//  WiFiSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import UIKit.UITableView

class WiFiSettingViewModel: NSObject {
    private(set) var sections: [WiFiSettingSectionType] = [.required, .optional]
    private var selectedSSID: String

    init(selectedSSID: String) {
        self.selectedSSID = selectedSSID
        super.init()
    }
}

// MARK: - UITableViewDataSource

extension WiFiSettingViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .required:
            return section.rows.count
        case .optional:
            return section.rows.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        switch section {
        case .required:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiSettingTableViewCell", for: indexPath) as! WiFiSettingTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: row.title)
            return cell
        case .optional:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell // swiftlint:disable:this force_cast
            cell.updateComponent(title: row.title)
            return cell
        }
    }
}
