//
//  KUIMaterialTextView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/3.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUIMaterialTextViewProps {
    let maxTextCount: Int
    let placeHolder: String?
    let backgroundColor: UIColor

    public init(maxTextCount: Int, placeHolder: String?, backgroundColor: UIColor) {
        self.maxTextCount = maxTextCount
        self.placeHolder = placeHolder
        self.backgroundColor = backgroundColor
    }
}

@available(*, deprecated, renamed: "KMaterialTextView", message: "Need to change to SwiftUI")
public class KUIMaterialTextView: UIView {
    public var onDidEndEditing: ((String) -> Void)?

    private var textView: UITextView!
    private var textViewPlaceHolderLabel: UILabel!
    private var dividerView: KUIDividerView!
    private var textCountLabel: KUITextCountLabel!

    private let maxTextCount: Int

    public init(props: KUIMaterialTextViewProps) {
        maxTextCount = props.maxTextCount

        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent(props: KUIMaterialTextViewProps) {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onTapDone))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 44)
        toolbar.setItems([flexSpaceItem, doneButtonItem], animated: true)

        textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = props.backgroundColor
        textView.inputAccessoryView = toolbar
        textView.font = .systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false

        textViewPlaceHolderLabel = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
        textViewPlaceHolderLabel.text = props.placeHolder
        textViewPlaceHolderLabel.backgroundColor = .clear
        textViewPlaceHolderLabel.font = .systemFont(ofSize: 15)
        textViewPlaceHolderLabel.textColor = UIColor.placeholderText
        textViewPlaceHolderLabel.lineBreakMode = .byWordWrapping
        textViewPlaceHolderLabel.numberOfLines = 0
        textViewPlaceHolderLabel.translatesAutoresizingMaskIntoConstraints = false

        dividerView = KUIDividerView(props: KUIDividerViewProps(color: .lightGray))
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        textCountLabel = KUITextCountLabel(props: KUITextCountLabelProps(
            textColor: .lightGray,
            maxCount: props.maxTextCount
        ))
        textCountLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textView)
        addSubview(textViewPlaceHolderLabel)
        addSubview(dividerView)
        addSubview(textCountLabel)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),

            dividerView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 3),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textCountLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 3),
            textCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func hidePlaceHolderLabel(text: String) {
        textViewPlaceHolderLabel.isHidden = text.isEmpty ? false : true
    }
}

// MARK: - UITextViewDelegate

extension KUIMaterialTextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let currentString = textView.text, let _range = Range(range, in: currentString) {
            let newString = currentString.replacingCharacters(in: _range, with: text)
            return newString.count <= maxTextCount
        } else {
            return false
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        textCountLabel.updateInputTextCount(text.count)
        hidePlaceHolderLabel(text: text)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        onDidEndEditing?(text)
    }

    @objc private func onTapDone() {
        textView.resignFirstResponder()
    }
}

public struct KMaterialTextViewProps {
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

public struct KMaterialTextView: View {
    private var props: KMaterialTextViewProps
    @FocusState private var isFocused: Bool

    public init(props: KMaterialTextViewProps) {
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

            KDividerView(props: KDividerViewProps(color: Color(uiColor: .lightGray)))

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
            KMaterialTextView(props: KMaterialTextViewProps(
                maxTextCount: 200,
                placeHolder: "メモを入力してください",
                inputText: $text
            ))
            .frame(height: 70)
            .padding()
        }
    }
}
