//
//  SideMenuViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/20.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

class SideMenuViewModel {
    enum Section: Hashable {
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

    enum SectionRowType: Hashable {
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

    init() {
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
}
