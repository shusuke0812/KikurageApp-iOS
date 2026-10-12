//
//  KUIMaterialTextField.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/3.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIMaterialTextFieldProps {
    let maxTextCount: Int
    let placeHolder: String?
    let alignment: TextAlignment
    let fontSize: CGFloat
    @Binding public var inputText: String

    public init(
        maxTextCount: Int,
        placeHolder: String? = nil,
        alignment: TextAlignment = .leading,
        fontSize: CGFloat = 15,
        inputText: Binding<String>
    ) {
        self.maxTextCount = maxTextCount
        self.placeHolder = placeHolder
        self.alignment = alignment
        self.fontSize = fontSize
        _inputText = inputText
    }
}

public struct KUIMaterialTextField: View {
    private var props: KUIMaterialTextFieldProps
    @FocusState private var isFocused: Bool

    public init(props: KUIMaterialTextFieldProps) {
        self.props = props
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: 3) {
            TextField(props.placeHolder ?? "", text: props.$inputText)
                .font(.system(size: props.fontSize))
                .multilineTextAlignment(props.alignment)
                .focused($isFocused)
                .onChange(of: props.inputText) { newValue in
                    if newValue.count > props.maxTextCount {
                        props.inputText = String(newValue.prefix(props.maxTextCount))
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(R.string.localizable.common_done()) {
                            isFocused = false
                        }
                    }
                }

            KUIDividerView(props: KUIDividerViewProps(color: Color(uiColor: .lightGray)))

            Text("\(props.inputText.count)/\(props.maxTextCount)")
                .font(.system(size: 12))
                .foregroundColor(Color(uiColor: .lightGray))
        }
    }
}

#Preview {
    KMaterialTextFieldPreviewWrapper()
}

private struct KMaterialTextFieldPreviewWrapper: View {
    @State private var text = ""

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            KUIMaterialTextField(props: KUIMaterialTextFieldProps(
                maxTextCount: 20,
                placeHolder: "レシピ名を入力してください",
                inputText: $text
            ))
            .padding()
        }
    }
}
