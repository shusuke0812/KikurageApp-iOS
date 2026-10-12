//
//  KUIHomeAdviceView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIHomeAdviceViewProps {
    let title: String
    let description: String
    let image: UIImage?

    public init(
        title: String,
        description: String,
        image: UIImage? = nil
    ) {
        self.title = title
        self.description = description
        self.image = image
    }
}

public struct KUIHomeAdviceView: View {
    private let props: KUIHomeAdviceViewProps

    public init(props: KUIHomeAdviceViewProps) {
        self.props = props
    }

    public var body: some View {
        KUIRoundedView(props: KUIRoundedViewProps(backgroundColor: Color(uiColor: .systemBackground))) {
            VStack(alignment: .leading, spacing: 0) {
                KUILabelWithImage(props: KUILabelWithImageProps(
                    variant: .imagePositionRight,
                    title: props.title,
                    image: props.image
                ))
                Spacer(minLength: 5)
                Text(props.description)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 5)
            }
            .padding(5)
        }
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KUIHomeAdviceView(props: KUIHomeAdviceViewProps(
            title: "アドバイス",
            description: "順調に育っとるぞ。その調子じゃ。",
            image: UIImage(systemName: "face.smiling")
        ))
        .frame(maxHeight: .infinity)
        .padding(.top, 15)
        .padding(.horizontal, 16)
    }
}
