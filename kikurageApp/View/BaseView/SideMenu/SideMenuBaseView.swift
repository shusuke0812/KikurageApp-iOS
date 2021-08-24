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
    /// デリゲート
    weak var delegate: SideMenuBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initViewTag()
        self.initSideMenuContent()
        self.initSideMenuBoarderLine()
    }
    // MARK: - Action
    @IBAction private func didTapContactCell(_ sender: Any) {
        self.delegate?.didTapContactCell()
    }
    @IBAction private func didTapGraphCell(_ sender: Any) {
        self.delegate?.didTapGraphCell()
    }
    @IBAction private func didTapCalendarCell(_ sender: Any) {
        self.delegate?.didTapCalendarCell()
    }
}
// MARK: - Initialized
extension SideMenuBaseView {
    private func initViewTag() {
        self.tag = Constants.ViewTag.sideMenuBase
    }
    private func initSideMenuContent() {
        self.calendarView.setSideMenuContent(title: "カレンダー", imageSystemName: "calendar")
        self.graphView.setSideMenuContent(title: "グラフ", imageSystemName: "waveform.path.ecg")
        self.contactView.setSideMenuContent(title: "問い合わせ", imageSystemName: "questionmark.circle")
        self.settingView.setSideMenuContent(title: "設定", imageSystemName: "gearshape")
        self.licenseView.setSideMenuContent(title: "著作権", imageSystemName: "info.circle")
        self.searchRecipeView.setSideMenuContent(title: "料理レシピ検索", imageSystemName: "magnifyingglass")
        self.kikurageDictionaryView.setSideMenuContent(title: "きくらげ豆知識", imageSystemName: "doc.text")
    }
    private func initSideMenuBoarderLine() {
        self.calendarView.setBoarder(topWidth: 0.5, bottomWidth: 0.5)
        self.graphView.setBoarder(topWidth: nil, bottomWidth: 0.5)
        self.contactView.setBoarder(topWidth: 0.5, bottomWidth: 0.5)
        self.settingView.setBoarder(topWidth: nil, bottomWidth: 0.5)
        self.licenseView.setBoarder(topWidth: nil, bottomWidth: 0.5)
        self.searchRecipeView.setBoarder(topWidth: 0.5, bottomWidth: 0.5)
        self.kikurageDictionaryView.setBoarder(topWidth: nil, bottomWidth: 0.5)
    }
}
