//
//  TopBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/3.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KUIKit
import SwiftUI

protocol TopBaseViewDelegate: AnyObject {
    func topBaseViewDidTappedTermsButton()
    func topBaseViewDidTappedPrivacyPolicyButton()
    func topBaseViewDidTappedLoginButton()
    func topBaseViewDidTappedSignUpButton()
}

struct TopBaseView: View {
    private let margin: CGFloat = 40

    weak var delegate: TopBaseViewDelegate?

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            VStack(spacing: margin) {
                HeaderView()
                BodyView(
                    onLogin: {
                        delegate?.topBaseViewDidTappedLoginButton()
                    },
                    onSignUp: {
                        delegate?.topBaseViewDidTappedSignUpButton()
                    },
                    onTerms: {
                        delegate?.topBaseViewDidTappedTermsButton()
                    },
                    onPrivacyPolicy: {
                        delegate?.topBaseViewDidTappedPrivacyPolicyButton()
                    }
                )
                FooterView()
            }
            .padding(EdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin))
        }
    }
}

private struct HeaderView: View {
    var body: some View {
        KImageView(props: KImageProps(image: R.image.kikurageDevice()))
            .frame(maxWidth: .infinity)
            .aspectRatio(.imageViewRatio, contentMode: .fill)
    }
}

private struct BodyView: View {
    let onLogin: () -> Void
    let onSignUp: () -> Void
    let onTerms: () -> Void
    let onPrivacyPolicy: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            KButton(
                props: KButtonProps(
                    variant: .primary,
                    title: R.string.localizable.screen_top_login_btn_name(),
                    accessibilityIdentifier: AccessibilityIdentifierManager.topLoginButton()
                ),
                onTap: onLogin
            )
            KButton(
                props: KButtonProps(
                    variant: .secondary,
                    title: R.string.localizable.screen_top_signup_btn_name()
                ),
                onTap: onSignUp
            )
            HStack(spacing: 20) {
                KUnderlinedTextButton(
                    props: KUnderlinedTextButtonProps(
                        title: R.string.localizable.screen_top_app_term(),
                        color: .black
                    ),
                    onTap: onTerms
                )
                KUnderlinedTextButton(
                    props: KUnderlinedTextButtonProps(
                        title: R.string.localizable.screen_top_app_privacy(),
                        color: .black
                    ),
                    onTap: onPrivacyPolicy
                )
            }
        }
    }
}

private struct FooterView: View {
    var body: some View {
        Spacer()
        Text(R.string.localizable.screen_top_copy_right())
    }
}

#Preview {
    TopBaseView()
}
