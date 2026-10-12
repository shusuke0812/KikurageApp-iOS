//
//  CalendarBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KSCalendarService
import KUIKit
import SwiftUI

struct CalendarBaseView: View {
    @StateObject var state: CalendarState

    init(state: CalendarState) {
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            if let startComponents = state.cultivationStartDateComponents,
               let currentComponents = state.currentDateComponents {
                ScrollView {
                    VStack(spacing: 20) {
                        KUIRoundedView {
                            KUICalendarView(
                                cultivationStartDateComponents: startComponents,
                                currentDateComponents: currentComponents
                            )
                            .padding(15)
                        }
                        .aspectRatio(1, contentMode: .fit)

                        KUIRoundedView {
                            Text(R.string.localizable.side_menu_clendar_term(state.cultivationTerm ?? 0))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(uiColor: .darkGray))
                        }
                        .frame(height: 60)
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 50)
                }
            }
        }
        .alert(state.errorMessage, isPresented: $state.hasError) {
            Button(R.string.localizable.common_alert_ok_btn_ok(), role: .cancel) {}
        }
    }
}

#Preview {
    let state = CalendarState()
    state.cultivationStartDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date().addingTimeInterval(-60 * 60 * 24 * 10))
    state.currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    state.cultivationTerm = 10
    return CalendarBaseView(state: state)
}
