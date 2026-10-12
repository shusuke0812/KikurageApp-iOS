//
//  LoginBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KUIKit
import SwiftUI

protocol LoginBaseViewDelegate: AnyObject {
    func loginBaseViewDidTappedLoginButton()
}

struct LoginBaseView: View {
    @StateObject var state: LoginViewState

    weak var delegate: LoginBaseViewDelegate?

    init(
        delegate: LoginBaseViewDelegate?,
        state: LoginViewState
    ) {
        self.delegate = delegate
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                KUITextField(props: KUITextFieldProps(
                    placeHolder: R.string.localizable.screen_login_email_textfield_placeholer(),
                    inputText: $state.email
                ))
                KUIPasswordField(props: KUITextFieldProps(
                    placeHolder: R.string.localizable.screen_login_password_textfield_placeholer(),
                    inputText: $state.password
                ))
                KUIButton(props: KUIButtonProps(
                    variant: .primary,
                    title: R.string.localizable.screen_login_login_btn_name(),
                    accessibilityIdentifier: Accessibility.generateIdentifier(),
                    enabled: $state.enabled
                )) {
                    delegate?.loginBaseViewDidTappedLoginButton()
                }
                Spacer()
            }
            .padding(.all, 40)
        }
    }
}

#Preview {
    LoginBaseView(
        delegate: nil, state: LoginViewState()
    )
}
