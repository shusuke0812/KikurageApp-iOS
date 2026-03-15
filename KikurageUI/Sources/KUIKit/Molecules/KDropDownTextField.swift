//
//  KDropDownTextField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/15.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KDropDownTextFieldProps {
    public let placeHolder: String
    @Binding public var date: Date
    @Binding public var hasError: Bool

    public init(
        placeHolder: String,
        date: Binding<Date>,
        hasError: Binding<Bool> = .constant(false)
    ) {
        self.placeHolder = placeHolder
        _date = date
        _hasError = hasError
    }
}

public struct KDropDownTextField: View {
    private var props: KDropDownTextFieldProps
    @State private var showDatePicker = false
    @State private var displayText: String = ""

    public init(props: KDropDownTextFieldProps) {
        self.props = props
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = .current
        return formatter.string(from: props.date)
    }

    public var body: some View {
        KTextField(props: KTextFieldProps(
            placeHolder: props.placeHolder,
            inputText: $displayText,
            hasError: props.$hasError
        ))
        .allowsHitTesting(false)
        .overlay(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    showDatePicker = true
                }
        )
        .onAppear {
            displayText = formattedDate
        }
        .onChange(of: props.date) { _ in
            displayText = formattedDate
        }
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 20) {
                DatePicker("", selection: props.$date, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()

                KButton(props: KButtonProps(
                    variant: .secondary,
                    title: R.string.localizable.common_done()
                ), onTap: {
                    showDatePicker = false
                })
                .padding(.horizontal, 24)
            }
            .presentationDetents([.height(300), .medium])
        }
    }
}

#Preview {
    KDropDownTextFieldPreviewWrapper()
}

private struct KDropDownTextFieldPreviewWrapper: View {
    @State private var date = Date()
    @State private var hasError = false

    var body: some View {
        KDropDownTextField(props: KDropDownTextFieldProps(
            placeHolder: "日付を選択",
            date: $date,
            hasError: $hasError
        ))
        .padding()
    }
}
