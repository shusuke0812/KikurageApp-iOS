//
//  KUIRoundedTextView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIRoundedTextViewProps {
    let backgroundColor: UIColor?
    let description: String
    
    public init(
        backgroundColor: UIColor? = .white,
        description: String
    ) {
        self.backgroundColor = backgroundColor
        self.description = description
    }
}

public class KUIRoundedTextView: UITextView {
    public init(props: KUIRoundedTextViewProps) {
        super.init(frame: .zero, textContainer: nil)
        setupComponent(props: props)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateDescription(text: String) {
        self.text = text
    }
    
    private func setupComponent(props: KUIRoundedTextViewProps) {
        backgroundColor = props.backgroundColor
        text  = props.description
        clipsToBounds = true
        layer.cornerRadius = .viewCornerRadius
        isEditable = false
        sizeToFit()
        textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
