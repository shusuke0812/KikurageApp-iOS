//
//  CalendarBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import HorizonCalendar
import KikurageUI
import UIKit

class CalendarBaseView: UIView {
    private var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        backgroundColor = .white

        contentView = UIView()
        contentView.backgroundColor = .systemGroupedBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupCalendarView(_ cultivationStartDateComponents: DateComponents, _ cultivationTerm: Int) {
        // Calendar
        let calendarParentView = KUIRoundedView(props: KUIRoundedViewProps(backgroundColor: .white))
        calendarParentView.translatesAutoresizingMaskIntoConstraints = false

        let calendarView = CalendarView(initialContent: makeContent(cultivationStartDateComponents))
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        let contentViewWidth = UIScreen.main.bounds.size.width - (15 * 2)

        // Cultivation start date
        let dateParentView = KUIRoundedView(props: KUIRoundedViewProps(backgroundColor: .white))
        dateParentView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = R.string.localizable.side_menu_clendar_term(cultivationTerm)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        // Constraint
        calendarParentView.addSubview(calendarView)
        dateParentView.addSubview(label)
        contentView.addSubview(calendarParentView)
        contentView.addSubview(dateParentView)

        NSLayoutConstraint.activate([
            calendarParentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            calendarParentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            calendarParentView.widthAnchor.constraint(equalToConstant: contentViewWidth),
            calendarParentView.heightAnchor.constraint(equalToConstant: contentViewWidth),

            calendarView.topAnchor.constraint(equalTo: calendarParentView.topAnchor, constant: 15),
            calendarView.leadingAnchor.constraint(equalTo: calendarParentView.leadingAnchor, constant: 15),
            calendarView.trailingAnchor.constraint(equalTo: calendarParentView.trailingAnchor, constant: -15),
            calendarView.bottomAnchor.constraint(equalTo: calendarParentView.bottomAnchor, constant: -15),

            label.leadingAnchor.constraint(equalTo: dateParentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: dateParentView.trailingAnchor, constant: -15),
            label.centerYAnchor.constraint(equalTo: dateParentView.centerYAnchor),

            dateParentView.topAnchor.constraint(equalTo: calendarParentView.bottomAnchor, constant: 20),
            dateParentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dateParentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            dateParentView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func makeContent(_ cultivationStartDateComponents: DateComponents) -> CalendarViewContent {
        let calendar = Calendar.current
        let nowDateComponents = DateHelper.getDateComponents()
        let startDate = calendar.date(from: cultivationStartDateComponents)!
        let endDate = calendar.date(from: nowDateComponents)!

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate ... endDate,
            monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions())
        )
    }
}

// MARK: - Config

extension CalendarBaseView {
    func initCalendarView(cultivationStartDateComponents: DateComponents, cultivationTerm: Int) {
        setupCalendarView(cultivationStartDateComponents, cultivationTerm)
    }
}
