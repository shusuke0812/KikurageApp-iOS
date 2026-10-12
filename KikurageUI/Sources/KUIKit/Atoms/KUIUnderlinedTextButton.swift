//
//  KUIUnderlinedTextButton.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/6.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIUnderlinedTextButtonProps {
    let title: String
    let color: Color
    let fontWeiht: Font.Weight

    public init(
        title: String,
        color: Color = .blue,
        fontWeiht: Font.Weight = .thin
    ) {
        self.title = title
        self.color = color
        self.fontWeiht = fontWeiht
    }
}

public struct KUIUnderlinedTextButton: View {
    private let props: KUIUnderlinedTextButtonProps

    public var onTap: (() -> Void)?

    public init(props: KUIUnderlinedTextButtonProps, onTap: (() -> Void)? = nil) {
        self.props = props
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: {
            onTap?()
        }, label: {
            Text(props.title)
                .foregroundColor(props.color)
                .font(.system(size: 15))
                .fontWeight(props.fontWeiht)
                .underline()
        })
    }
}
