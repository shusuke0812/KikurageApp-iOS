//
//  PostRecipeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KSRecipeService
import KUIKit
import SwiftUI
import UIKit

protocol PostRecipeBaseViewDelegate: AnyObject {
    func postRecipeBaseViewDidTapImageSlot(at index: Int)
    func postRecipeBaseViewDidTapPostButton()
    func postRecipeBaseViewDidConfirmPost()
    func postRecipeBaseViewDidConfirmPostSuccess()
}

struct PostRecipeBaseView: View {
    @StateObject var state: PostRecipeState

    weak var delegate: PostRecipeBaseViewDelegate?

    init(delegate: PostRecipeBaseViewDelegate?, state: PostRecipeState) {
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
                            delegate?.postRecipeBaseViewDidTapImageSlot(at: index)
                        }
                    )
                }
                .frame(height: 180)
                .padding(.top, 30)
                .padding(.horizontal, 8)

                KMaterialTextField(props: KMaterialTextFieldProps(
                    maxTextCount: 20,
                    placeHolder: R.string.localizable.screen_post_recipe_recipe_name_textfield_placeholder(),
                    inputText: $state.name
                ))
                .padding(.top, 15)
                .padding(.horizontal, 8)

                KMaterialTextView(props: KMaterialTextViewProps(
                    maxTextCount: 100,
                    placeHolder: R.string.localizable.screen_post_recipe_recipe_memo_textview_placeholder(),
                    inputText: $state.memo
                ))
                .frame(height: 70)
                .padding(.top, 30)
                .padding(.horizontal, 8)

                KDropDownTextField(props: KDropDownTextFieldProps(
                    placeHolder: R.string.localizable.screen_post_recipe_recipe_date_textfield_placeholder(),
                    date: $state.date
                ))
                .padding(.top, 20)
                .padding(.horizontal, 8)

                Spacer(minLength: 0)

                KButton(props: KButtonProps(
                    variant: .primary,
                    title: R.string.localizable.screen_post_recipe_post_button_title()
                )) {
                    delegate?.postRecipeBaseViewDidTapPostButton()
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
            case .confirmPost:
                return Alert(
                    title: Text(R.string.localizable.screen_post_recipe_alert_post_recipe_title()),
                    primaryButton: .default(Text(R.string.localizable.common_alert_ok_btn_ok())) {
                        delegate?.postRecipeBaseViewDidConfirmPost()
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
                    title: Text(R.string.localizable.screen_post_recipe_alert_post_recipe_success_title()),
                    dismissButton: .default(Text(R.string.localizable.common_alert_ok_btn_ok())) {
                        delegate?.postRecipeBaseViewDidConfirmPostSuccess()
                    }
                )
            }
        }
    }
}

#Preview {
    PostRecipeBaseView(delegate: nil, state: PostRecipeState(maxImageCount: Constants.CameraCollectionCell.maxNumber))
}
