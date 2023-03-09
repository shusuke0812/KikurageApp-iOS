//
//  WiFiListViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation
import UIKit.UITableView

class WiFiListViewModel: NSObject {
    private let sections: [ WiFiListSectionType] = [.spec, .enterWifi, .selectWifi]

    override init() {
        super.init()
    }
}

// MARK: - UITableViewDataSource

extension WiFiListViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .spec, .enterWifi:
            return sections[section].rows.count
        case .selectWifi:
            // TODO: searched wifi count
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .spec:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListSpecTableViewCell", for: indexPath) as! WiFiListSpecTableViewCell  // swiftlint:disable:this force_cast
            cell.updateComponent(title: section.rows[indexPath.row].title)
            return cell
        case .enterWifi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell  // swiftlint:disable:this force_cast
            cell.updateComponent(title: section.rows[indexPath.row].title)
            return cell
        case .selectWifi:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WiFiListTableViewCell", for: indexPath) as! WiFiListTableViewCell  // swiftlint:disable:this force_cast
            return cell
        }
    }
}
