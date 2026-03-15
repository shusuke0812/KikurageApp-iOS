//
//  DeviceRegisterBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KSDeviceRegisterService
import KUIKit
import SwiftUI
import UIKit

protocol DeviceRegisterBaseViewDelegate: AnyObject {
    func deviceRegisterBaseViewDidTappedDeviceRegisterButton()
    func deviceRegisterBaseViewDidTappedQrcodeReaderButton()
}

struct DeviceRegisterBaseView: View {
    @StateObject var state: DeviceRegisterState
    @State private var cultivationStartDateHasError = false

    weak var delegate: DeviceRegisterBaseViewDelegate?

    init(
        delegate: DeviceRegisterBaseViewDelegate?,
        state: DeviceRegisterState
    ) {
        self.delegate = delegate
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    KTextField(props: KTextFieldProps(
                        placeHolder: R.string.localizable.screen_device_register_productkey_textfield_placeholer(),
                        inputText: $state.productKey
                    ))
                    .padding(.top, 40)

                    KTextField(props: KTextFieldProps(
                        placeHolder: R.string.localizable.screen_device_register_kikurage_name_textfield_placeholer(),
                        inputText: $state.kikurageName
                    ))
                    .padding(.top, 25)

                    KDropDownTextField(props: KDropDownTextFieldProps(
                        placeHolder: R.string.localizable.screen_device_register_cultivation_start_date_textfield_placeholer(),
                        date: $state.cultivationStartDate,
                        hasError: $cultivationStartDateHasError
                    ))
                    .padding(.top, 25)

                    Button(R.string.localizable.screen_device_register_qrcode_btn_name()) {
                        delegate?.deviceRegisterBaseViewDidTappedQrcodeReaderButton()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(Color(uiColor: .systemBlue))
                    .padding(.top, 35)

                    if state.isQrcodeReaderVisible {
                        QRCodeReaderView(
                            session: state.captureSession,
                            orientation: state.videoOrientation
                        )
                        .frame(height: 240)
                        .background(Color.white)
                        .padding(.top, 15)
                    }

                    KButton(props: KButtonProps(
                        variant: .primary,
                        title: R.string.localizable.screen_device_register_register_btn_name()
                    )) {
                        delegate?.deviceRegisterBaseViewDidTappedDeviceRegisterButton()
                    }
                    .padding(.top, 35)
                    .padding(.bottom, 40)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    DeviceRegisterBaseView(delegate: nil, state: DeviceRegisterState())
}
