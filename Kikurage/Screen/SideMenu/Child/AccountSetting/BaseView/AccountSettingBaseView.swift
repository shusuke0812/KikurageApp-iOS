//
//  AccountSettingBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/1.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KSAccountSettingService
import KUIKit
import SwiftUI

protocol AccountSettingBaseViewDelegate: AnyObject {
    func settingBaseViewDidTapEditButton()
    func settingBaseViewDidTapUserImageView()
}

struct AccountSettingBaseView: View {
    @StateObject var state: AccountSettingState
    weak var delegate: AccountSettingBaseViewDelegate?

    private let userImageViewWidth: CGFloat = 160

    init(state: AccountSettingState, delegate: AccountSettingBaseViewDelegate?) {
        _state = StateObject(wrappedValue: state)
        self.delegate = delegate
    }

    var body: some View {
        VStack(spacing: 0) {
            KCircleImageView(props: KCircleImageViewProps(
                image: R.image.hakase(),
                width: userImageViewWidth
            ))
            .padding(.top, 40)
            .onTapGesture {
                delegate?.settingBaseViewDidTapUserImageView()
            }

            KMaterialTextField(props: KMaterialTextFieldProps(
                maxTextCount: 30,
                alignment: .center,
                fontSize: 20,
                inputText: $state.kikurageName
            ))
            .padding(.horizontal, 16)
            .padding(.top, 40)

            Spacer(minLength: 0)

            KButton(props: KButtonProps(
                variant: .primary,
                title: R.string.localizable.side_menu_setting_edit_btn_title()
            ), onTap: {
                delegate?.settingBaseViewDidTapEditButton()
            })
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    let state = AccountSettingState()
    state.kikurageName = "きくらげ"
    return AccountSettingBaseView(state: state, delegate: nil)
}
