//
//  KUISideMenuItemTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/15.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

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
