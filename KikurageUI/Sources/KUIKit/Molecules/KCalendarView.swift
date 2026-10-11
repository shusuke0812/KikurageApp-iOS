//
//  KCalendarView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2026/10/11.
//

import HorizonCalendar
import SwiftUI

public struct KCalendarView: UIViewRepresentable {
    private let cultivationStartDateComponents: DateComponents
    private let currentDateComponents: DateComponents

    public init(cultivationStartDateComponents: DateComponents, currentDateComponents: DateComponents) {
        self.cultivationStartDateComponents = cultivationStartDateComponents
        self.currentDateComponents = currentDateComponents
    }

    public func makeUIView(context: Context) -> CalendarView {
        CalendarView(initialContent: makeContent())
    }

    public func updateUIView(_ uiView: CalendarView, context: Context) {}

    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let startDate = calendar.date(from: cultivationStartDateComponents) ?? Date()
        let endDate = calendar.date(from: currentDateComponents) ?? Date()

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate ... endDate,
            monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions())
        )
    }
}
