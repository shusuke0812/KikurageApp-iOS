//
//  CalendarState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

public final class CalendarState: ObservableObject {
    @Published public var cultivationStartDateComponents: DateComponents?
    @Published public var currentDateComponents: DateComponents?
    @Published public var cultivationTerm: Int?
    @Published public var hasError: Bool = false
    @Published public var errorMessage: String = ""

    public init() {}
}
