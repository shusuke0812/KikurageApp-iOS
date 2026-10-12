//
//  KUICultivationDetailDescriptionView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUICultivationDetailDescriptionViewProps {
    let image: UIImage?
    let title: String
    let dateString: String
    let description: String

    public init(
        image: UIImage?,
        title: String,
        dateString: String,
        description: String
    ) {
        self.image = image
        self.title = title
        self.dateString = dateString
        self.description = description
    }
}

public struct KUICultivationDetailDescriptionView: View {
    private let props: KUICultivationDetailDescriptionViewProps
    private let iconImageWidth: CGFloat = 50

    public init(props: KUICultivationDetailDescriptionViewProps) {
        self.props = props
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack(spacing: 15) {
                KUICircleImageView(props: KUICircleImageViewProps(image: props.image, width: iconImageWidth))

                VStack(alignment: .leading, spacing: 7) {
                    Text(props.title)
                        .font(.system(size: 17))
                    Text(props.dateString)
                        .font(.system(size: 14))
                        .foregroundColor(Color(uiColor: .lightGray))
                }
            }

            KUIRoundedView {
                Text(props.description)
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(15)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KUICultivationDetailDescriptionView(props: KUICultivationDetailDescriptionViewProps(
            image: UIImage(systemName: "face.smiling"),
            title: "栽培メモ",
            dateString: "2024/01/01",
            description: "今日はきのこがよく育っていました。"
        ))
        .padding(.top, 25)
        .padding(.horizontal, 15)
    }
}
