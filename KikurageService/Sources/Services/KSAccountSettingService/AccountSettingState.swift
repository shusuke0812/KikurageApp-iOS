//
//  AccountSettingState.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

public final class AccountSettingState: ObservableObject {
    @Published public var kikurageName: String = ""

    public init() {}
}
