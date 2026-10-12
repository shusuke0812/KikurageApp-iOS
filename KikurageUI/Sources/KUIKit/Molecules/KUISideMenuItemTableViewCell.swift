//
//  KUISideMenuItemTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/15.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUISideMenuItemRowProps {
    let title: String
    let iconImageName: String

    public init(title: String, iconImageName: String) {
        self.title = title
        self.iconImageName = iconImageName
    }
}

public struct KUISideMenuItemRow: View {
    private let props: KUISideMenuItemRowProps

    public init(props: KUISideMenuItemRowProps) {
        self.props = props
    }

    public var body: some View {
        HStack(spacing: 18) {
            Image(systemName: props.iconImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(.black)

            Text(props.title)
                .font(.system(size: 16))
                .foregroundColor(.primary)

            Spacer(minLength: 0)
        }
        .padding(.leading, 16)
        .padding(.trailing, 6)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        VStack(spacing: 0) {
            KUISideMenuItemRow(props: KUISideMenuItemRowProps(title: "カレンダー", iconImageName: "calendar"))
            KUISideMenuItemRow(props: KUISideMenuItemRowProps(title: "グラフ", iconImageName: "waveform.path.ecg"))
        }
    }
}
