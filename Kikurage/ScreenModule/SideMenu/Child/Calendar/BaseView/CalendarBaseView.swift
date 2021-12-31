//
//  CalendarBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import HorizonCalendar

protocol CalendarBaseViewDelegate: AnyObject {
    /// 閉じるボタンを押した時の処理
    func didTapCloseButton()
}

class CalendarBaseView: UIView {
    @IBOutlet private weak var navigationItem: UINavigationItem!
    @IBOutlet private weak var contentView: UIView!

    weak var delegate: CalendarBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        initCalendarView()
    }

    // MARK: - Action

    @IBAction private func didTapCloseButton(_ sender: Any) {
        delegate?.didTapCloseButton()
    }
}

// MARK: - Initialized

extension CalendarBaseView {
    private func initUI() {
        contentView.backgroundColor = .systemGroupedBackground
        navigationItem.title = R.string.localizable.side_menu_clendar_title()
    }
    private func initCalendarView() {
        let parentView = UIView()
        parentView.backgroundColor = .white
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = .viewCornerRadius
        parentView.translatesAutoresizingMaskIntoConstraints = false

        let calendarView = CalendarView(initialContent: makeContent())
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        parentView.addSubview(calendarView)
        contentView.addSubview(parentView)

        let contentViewWidth = UIScreen.main.bounds.size.width - (15 * 2)

        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            parentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            parentView.widthAnchor.constraint(equalToConstant: contentViewWidth),
            parentView.heightAnchor.constraint(equalToConstant: contentViewWidth),

            calendarView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 15),
            calendarView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 15),
            calendarView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -15),
            calendarView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -15)
        ])
    }
    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let _defaultComponents = DateHelper.getDateComponents()
        let startDate = calendar.date(from: AppConfig.shared.cultivationStartDateComponents ?? _defaultComponents)!
        let endDate = calendar.date(from: AppConfig.shared.nowDateComponents)!

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions())
        )
    }
}
