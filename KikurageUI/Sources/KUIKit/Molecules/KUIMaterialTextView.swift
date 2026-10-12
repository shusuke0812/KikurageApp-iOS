//
//  KUIMaterialTextView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/3.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIMaterialTextViewProps {
    let maxTextCount: Int
    let placeHolder: String?
    @Binding public var inputText: String

    public init(
        maxTextCount: Int,
        placeHolder: String? = nil,
        inputText: Binding<String>
    ) {
        self.maxTextCount = maxTextCount
        self.placeHolder = placeHolder
        _inputText = inputText
    }
}

public struct KUIMaterialTextView: View {
    private var props: KUIMaterialTextViewProps
    @FocusState private var isFocused: Bool

    public init(props: KUIMaterialTextViewProps) {
        self.props = props
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: 3) {
            ZStack(alignment: .topLeading) {
                if props.inputText.isEmpty, let placeHolder = props.placeHolder {
                    Text(placeHolder)
                        .font(.system(size: 15))
                        .foregroundColor(Color(uiColor: .placeholderText))
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
                TextEditor(text: props.$inputText)
                    .font(.system(size: 15))
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
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
            }

            KUIDividerView(props: KUIDividerViewProps(color: Color(uiColor: .lightGray)))

            Text("\(props.inputText.count)/\(props.maxTextCount)")
                .font(.system(size: 12))
                .foregroundColor(Color(uiColor: .lightGray))
        }
    }
}

#Preview {
    KMaterialTextViewPreviewWrapper()
}

private struct KMaterialTextViewPreviewWrapper: View {
    @State private var text = ""

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            KUIMaterialTextView(props: KUIMaterialTextViewProps(
                maxTextCount: 200,
                placeHolder: "メモを入力してください",
                inputText: $text
            ))
            .frame(height: 70)
            .padding()
        }
    }
}
