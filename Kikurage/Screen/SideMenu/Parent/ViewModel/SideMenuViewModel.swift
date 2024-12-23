//
//  SideMenuViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/20.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageUI
import UIKit.UITableView

class SideMenuViewModel: NSObject {
    enum Section {
        case history
        case support
        case help
        case setting
        case debug

        var rows: [SectionRowType] {
            switch self {
            case .history: return [.calendar, .graph]
            case .support: return [.contact, .accountSetting, .license]
            case .help: return [.searchRecipe, .kikurageDictionary]
            case .setting: return [.wifi]
            case .debug: return [.debugTry]
            }
        }
    }

    enum SectionRowType {
        case calendar
        case graph
        case contact
        case accountSetting
        case license
        case searchRecipe
        case kikurageDictionary
        case wifi
        case debugTry

        var title: String {
            switch self {
            case .calendar:
                return R.string.localizable.side_menu_content_clendar_subtitle()
            case .graph:
                return R.string.localizable.side_menu_content_graph_subtitle()
            case .contact:
                return R.string.localizable.side_menu_content_contact_subtitle()
            case .accountSetting:
                return R.string.localizable.side_menu_content_account_setting_subtitle()
            case .license:
                return R.string.localizable.side_menu_content_license_subtitle()
            case .searchRecipe:
                return R.string.localizable.side_menu_content_search_recipe_subtitle()
            case .kikurageDictionary:
                return R.string.localizable.side_menu_content_kikurage_dictionary_subtitle()
            case .wifi:
                return R.string.localizable.side_menu_content_wifi_subtitle()
            case .debugTry:
                return R.string.localizable.side_menu_content_debug_try_subtitle()
            }
        }

        var iconImageName: String {
            switch self {
            case .calendar:
                return "calendar"
            case .graph:
                return "waveform.path.ecg"
            case .contact:
                return "questionmark.circle"
            case .accountSetting:
                return "gear"
            case .license:
                return "info.circle"
            case .searchRecipe:
                return "magnifyingglass"
            case .kikurageDictionary:
                return "doc.text"
            case .wifi:
                return "wifi"
            case .debugTry:
                return "checkmark.seal.fill"
            }
        }
    }

    private(set) var sections: [Section] = []

    override init() {
        super.init()
        setSection()
    }
}

// MARK: - Config

extension SideMenuViewModel {
    private func setSection() {
        #if PRODUCTION
            sections = [.history, .support, .help, .setting]
        #else
            sections = [.history, .support, .help, .setting, .debug]
        #endif
    }

    private func makeSectionCell(tableView: UITableView, section: Section, indexPath: IndexPath) -> KUISideMenuItemTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KUISideMenuItemTableViewCell.identifier, for: indexPath) as! KUISideMenuItemTableViewCell // swiftlint:disable:this force_cast
        let rowType = section.rows[indexPath.row]

        cell.setSideMenuContent(title: rowType.title, iconImageName: rowType.iconImageName)

        return cell
    }
}

// MARK: - UITableView DataSource

extension SideMenuViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        return makeSectionCell(tableView: tableView, section: section, indexPath: indexPath)
    }
}
