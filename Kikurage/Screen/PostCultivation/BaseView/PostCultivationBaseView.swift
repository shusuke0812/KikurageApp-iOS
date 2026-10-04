//
//  PostCultivationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/8.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KSCultivationService
import KUIKit
import SwiftUI
import UIKit

protocol PostCultivationBaseViewDelegate: AnyObject {
    func postCultivationBaseViewDidTapImageSlot(at index: Int)
    func postCultivationBaseViewDidTapPostButton()
    func postCultivationBaseViewDidConfirmPost()
    func postCultivationBaseViewDidConfirmPostSuccess()
}

struct PostCultivationBaseView: View {
    @StateObject var state: PostCultivationState

    weak var delegate: PostCultivationBaseViewDelegate?

    init(delegate: PostCultivationBaseViewDelegate?, state: PostCultivationState) {
        self.delegate = delegate
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    KSelectImageGridView(
                        selectedImages: $state.selectedImages,
                        onTapSlot: { index in
                            delegate?.postCultivationBaseViewDidTapImageSlot(at: index)
                        }
                    )
                }
                .frame(height: 180)
                .padding(.top, 30)
                .padding(.horizontal, 8)

                KMaterialTextView(props: KMaterialTextViewProps(
                    maxTextCount: 200,
                    placeHolder: R.string.localizable.screen_post_cultivation_textview_placeholder(),
                    inputText: $state.memo
                ))
                .frame(height: 70)
                .padding(.top, 15)
                .padding(.horizontal, 8)

                KDropDownTextField(props: KDropDownTextFieldProps(
                    placeHolder: R.string.localizable.screen_post_cultivation_date_textfield_placeholder(),
                    date: $state.date
                ))
                .padding(.top, 20)
                .padding(.horizontal, 8)

                Spacer(minLength: 0)

                KButton(props: KButtonProps(
                    variant: .primary,
                    title: R.string.localizable.screen_post_cultivation_post_button_title()
                )) {
                    delegate?.postCultivationBaseViewDidTapPostButton()
                }
                .frame(height: 45)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }

            if state.isPosting {
                KProgressHUDView()
            }
        }
        .alert(item: $state.alert) { alert in
            switch alert {
            case .validationFailed:
                return Alert(
                    title: Text(R.string.localizable.screen_post_cultivation_valid_view_date()),
                    dismissButton: .default(Text(R.string.localizable.common_alert_ok_btn_ok()))
                )
            case .confirmPost:
                return Alert(
                    title: Text(R.string.localizable.screen_post_cultivation_alert_post_cultivation_title()),
                    primaryButton: .default(Text(R.string.localizable.common_alert_ok_btn_ok())) {
                        delegate?.postCultivationBaseViewDidConfirmPost()
                    },
                    secondaryButton: .cancel(Text(R.string.localizable.common_alert_cancel_btn_cancel()))
                )
            case .postFailed(let message):
                return Alert(
                    title: Text(message),
                    dismissButton: .default(Text(R.string.localizable.common_alert_ok_btn_ok()))
                )
            case .postSucceeded:
                return Alert(
                    title: Text(R.string.localizable.screen_post_cultivation_alert_post_cultivation_success_title()),
                    dismissButton: .default(Text(R.string.localizable.common_alert_ok_btn_ok())) {
                        delegate?.postCultivationBaseViewDidConfirmPostSuccess()
                    }
                )
            }
        }
    }
}

#Preview {
    PostCultivationBaseView(delegate: nil, state: PostCultivationState(maxImageCount: Constants.CameraCollectionCell.maxNumber))
}
