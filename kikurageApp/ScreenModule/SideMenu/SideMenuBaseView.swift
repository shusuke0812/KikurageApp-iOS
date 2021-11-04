//
//  SideMenuBaseView.swift
//  kikurageApp
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
        calendarView.setSideMenuContent(title: "カレンダー", imageSystemName: "calendar")
        graphView.setSideMenuContent(title: "グラフ", imageSystemName: "waveform.path.ecg")
        contactView.setSideMenuContent(title: "問い合わせ", imageSystemName: "questionmark.circle")
        settingView.setSideMenuContent(title: "設定", imageSystemName: "gear")
        licenseView.setSideMenuContent(title: "著作権", imageSystemName: "info.circle")
        searchRecipeView.setSideMenuContent(title: "料理レシピ検索", imageSystemName: "magnifyingglass")
        kikurageDictionaryView.setSideMenuContent(title: "きくらげ豆知識", imageSystemName: "doc.text")
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
