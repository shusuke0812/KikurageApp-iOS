//
//  LoginBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KSLoginService
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
                KTextField(props: KTextFieldProps(
                    placeHolder: R.string.localizable.screen_login_email_textfield_placeholer(),
                    inputText: $state.email
                ))
                KPasswordField(props: KTextFieldProps(
                    placeHolder: R.string.localizable.screen_login_password_textfield_placeholer(),
                    inputText: $state.password
                ))
                KButton(props: KButtonProps(
                    variant: .primary,
                    title: R.string.localizable.screen_login_login_btn_name(),
                    accessibilityIdentifier: AccessibilityIdentifierManager.loginLoginButton(),
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
