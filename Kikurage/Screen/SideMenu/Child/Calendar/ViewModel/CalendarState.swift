//
//  CalendarState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

final class CalendarState: ObservableObject {
    @Published var cultivationStartDateComponents: DateComponents?
    @Published var currentDateComponents: DateComponents?
    @Published var cultivationTerm: Int?
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
}
