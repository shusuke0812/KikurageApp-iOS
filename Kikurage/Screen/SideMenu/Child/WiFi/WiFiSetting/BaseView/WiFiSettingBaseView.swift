//
//  WiFiSettingBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KUIKit
import SwiftUI

protocol WiFiSettingBaseViewDelegate: AnyObject {
    func wifiSettingBaseViewDidTapSetting()
    func wifiSettingBaseViewDidConfirmAlert()
}

struct WiFiSettingBaseView: View {
    @StateObject var state: WiFiSettingState
    weak var delegate: WiFiSettingBaseViewDelegate?

    private let titleWidth: CGFloat = 85

    init(state: WiFiSettingState, delegate: WiFiSettingBaseViewDelegate?) {
        _state = StateObject(wrappedValue: state)
        self.delegate = delegate
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                List {
                    Section(WiFiSettingSectionType.required.title) {
                        HStack {
                            Text(WiFiSettingSectionType.SectionRowType.ssid.title)
                                .frame(width: titleWidth, alignment: .leading)
                            TextField("", text: $state.ssid)
                        }

                        HStack {
                            Text(WiFiSettingSectionType.SectionRowType.password.title)
                                .frame(width: titleWidth, alignment: .leading)
                            TextField("", text: $state.password)
                        }
                    }

                    Section(WiFiSettingSectionType.optional.title) {
                        ForEach(WiFiSettingSectionType.optional.rows, id: \.self) { row in
                            HStack {
                                Text(row.title)
                                Spacer(minLength: 0)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .systemGray3))
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)

                Button(action: {
                    delegate?.wifiSettingBaseViewDidTapSetting()
                }) {
                    Text(R.string.localizable.side_menu_wifi_setting_button_title())
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .background(Color(uiColor: R.color.subColor() ?? .systemBlue))
                .foregroundColor(.white)
                .cornerRadius(.buttonCornerRadius)
                .opacity(state.isButtonEnabled ? 1 : 0.4)
                .disabled(!state.isButtonEnabled)
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }

            if state.isSettingUp {
                KUIProgressHUDView()
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .alert(item: $state.alert) { alert in
            Alert(
                title: Text(alert.message),
                dismissButton: .default(Text(R.string.localizable.common_alert_ok_btn_ok())) {
                    delegate?.wifiSettingBaseViewDidConfirmAlert()
                }
            )
        }
    }
}

#Preview {
    let state = WiFiSettingState()
    state.ssid = "Kikurage-WiFi"
    return WiFiSettingBaseView(state: state, delegate: nil)
}
