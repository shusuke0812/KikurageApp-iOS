//
//  LoginBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KUIKit
import SwiftUI
import UIKit

protocol LoginBaseViewDelegate: AnyObject {
    func loginBaseViewDidTappedLoginButton()
}

struct LoginBaseView: View {
    @Binding var inputEmailText: String
    @Binding var inputPasswordText: String

    weak var delegate: LoginBaseViewDelegate?

    init(
        delegate: LoginBaseViewDelegate?,
        inputEmailText: Binding<String> = .constant(""),
        inputPasswordText: Binding<String> = .constant("")
    ) {
        self.delegate = delegate
        _inputEmailText = inputEmailText
        _inputPasswordText = inputPasswordText
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                KTextField(props: KTextFieldProps(
                    placeHolder: R.string.localizable.screen_login_email_textfield_placeholer(),
                    inputText: $inputEmailText
                ))
                KPasswordField(props: KTextFieldProps(
                    placeHolder: R.string.localizable.screen_login_password_textfield_placeholer(),
                    inputText: $inputPasswordText
                ))
                KButton(props: KButtonProps(
                    variant: .primary,
                    title: R.string.localizable.screen_login_login_btn_name(),
                    accessibilityIdentifier: AccessibilityIdentifierManager.loginLoginButton()
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
        delegate: nil
    )
}
