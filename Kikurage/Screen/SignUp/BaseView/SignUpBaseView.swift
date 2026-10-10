//
//  SignUpBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/5.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KSSignUpService
import KUIKit
import SwiftUI
import UIKit

protocol SignUpBaseViewDelegate: AnyObject {
    func signUpBaseViewDidTappedRegisterUserButton()
}

struct SignUpBaseView: View {
    @StateObject var state: SignUpState

    weak var delegate: SignUpBaseViewDelegate?

    init(
        delegate: SignUpBaseViewDelegate?,
        state: SignUpState
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
                    placeHolder: R.string.localizable.screen_signup_email_textfield_placeholer(),
                    inputText: $state.email
                ))
                KPasswordField(props: KTextFieldProps(
                    placeHolder: R.string.localizable.screen_signup_password_textfield_placeholer(),
                    inputText: $state.password
                ))
                KButton(props: KButtonProps(
                    variant: .primary,
                    title: R.string.localizable.screen_signup_signup_btn_name(),
                    enabled: $state.enabled
                )) {
                    delegate?.signUpBaseViewDidTappedRegisterUserButton()
                }
                Spacer()
            }
            .padding(.all, 40)
        }
    }
}

#Preview {
    SignUpBaseView(delegate: nil, state: SignUpState())
}
