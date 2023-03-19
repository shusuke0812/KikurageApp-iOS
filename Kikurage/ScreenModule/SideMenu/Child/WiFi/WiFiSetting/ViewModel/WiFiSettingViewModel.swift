//
//  WiFiSettingViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

class WiFiSettingViewModel: NSObject {
    private var selectedSSID: String

    init(selectedSSID: String) {
        self.selectedSSID = selectedSSID
        super.init()
    }
}
