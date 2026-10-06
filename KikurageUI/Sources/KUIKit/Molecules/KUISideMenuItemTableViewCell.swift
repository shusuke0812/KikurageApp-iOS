//
//  KUISideMenuItemTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/15.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

@available(*, deprecated, renamed: "KSideMenuItemRow", message: "Need to change to SwiftUI")
public class KUISideMenuItemTableViewCell: UITableViewCell {
    public static let identifier = "SideMenuItemTableViewCell"

    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setSideMenuContent(title: String, iconImageName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconImageName)
    }

    private func setupComponent() {
        contentView.backgroundColor = .systemGroupedBackground

        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .black
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 18),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
}

public struct KSideMenuItemRowProps {
    let title: String
    let iconImageName: String

    public init(title: String, iconImageName: String) {
        self.title = title
        self.iconImageName = iconImageName
    }
}

public struct KSideMenuItemRow: View {
    private let props: KSideMenuItemRowProps

    public init(props: KSideMenuItemRowProps) {
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
            KSideMenuItemRow(props: KSideMenuItemRowProps(title: "カレンダー", iconImageName: "calendar"))
            KSideMenuItemRow(props: KSideMenuItemRowProps(title: "グラフ", iconImageName: "waveform.path.ecg"))
        }
    }
}
