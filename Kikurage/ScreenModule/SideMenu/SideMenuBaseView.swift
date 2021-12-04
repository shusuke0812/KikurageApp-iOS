//
//  SideMenuBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol SideMenuBaseViewDelegate: AnyObject {
    /// 問い合わせをタップした時の処理
    func didTapContactCell()
    /// カレンダーをタップした時の処理
    func didTapCalendarCell()
    /// グラフをタップした時の処理
    func didTapGraphCell()
}

class SideMenuBaseView: UIView {
    @IBOutlet weak var sideMenuParentView: UIView!
    @IBOutlet private weak var calendarView: SideMenuContentView!
    @IBOutlet private weak var graphView: SideMenuContentView!
    @IBOutlet private weak var contactView: SideMenuContentView!
    @IBOutlet private weak var settingView: SideMenuContentView!
    @IBOutlet private weak var licenseView: SideMenuContentView!
    @IBOutlet private weak var searchRecipeView: SideMenuContentView!
    @IBOutlet private weak var kikurageDictionaryView: SideMenuContentView!

    weak var delegate: SideMenuBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initSideMenuContent()
        initSideMenuBoarderLine()
    }
    // MARK: - Action
    @IBAction private func didTapContactCell(_ sender: Any) {
        delegate?.didTapContactCell()
    }
    @IBAction private func didTapGraphCell(_ sender: Any) {
        delegate?.didTapGraphCell()
    }
    @IBAction private func didTapCalendarCell(_ sender: Any) {
        delegate?.didTapCalendarCell()
    }
}
// MARK: - Initialized
extension SideMenuBaseView {
    private func initSideMenuContent() {
        calendarView.setSideMenuContent(title: R.string.localizable.side_menu_content_clendar_subtitle(), imageSystemName: "calendar")
        graphView.setSideMenuContent(title: R.string.localizable.side_menu_content_clendar_subtitle(), imageSystemName: "waveform.path.ecg")
        contactView.setSideMenuContent(title: R.string.localizable.side_menu_content_contact_subtitle(), imageSystemName: "questionmark.circle")
        settingView.setSideMenuContent(title: R.string.localizable.side_menu_content_setting_subtitle(), imageSystemName: "gear")
        licenseView.setSideMenuContent(title: R.string.localizable.side_menu_content_license_subtitle(), imageSystemName: "info.circle")
        searchRecipeView.setSideMenuContent(title: R.string.localizable.side_menu_content_search_recipe_subtitle(), imageSystemName: "magnifyingglass")
        kikurageDictionaryView.setSideMenuContent(title: R.string.localizable.side_menu_content_kikurage_dictionary_subtitle(), imageSystemName: "doc.text")
    }
    private func initSideMenuBoarderLine() {
        calendarView.setBoarder(topWidth: 0.5, bottomWidth: 0.5)
        graphView.setBoarder(topWidth: nil, bottomWidth: 0.5)
        contactView.setBoarder(topWidth: 0.5, bottomWidth: 0.5)
        settingView.setBoarder(topWidth: nil, bottomWidth: 0.5)
        licenseView.setBoarder(topWidth: nil, bottomWidth: 0.5)
        searchRecipeView.setBoarder(topWidth: 0.5, bottomWidth: 0.5)
        kikurageDictionaryView.setBoarder(topWidth: nil, bottomWidth: 0.5)
    }
}
