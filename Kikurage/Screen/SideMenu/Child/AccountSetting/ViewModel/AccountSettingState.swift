//
//  AccountSettingState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2026/10/11.
//

import Combine
import Foundation

final class AccountSettingState: ObservableObject {
    @Published var kikurageName: String = ""
}
