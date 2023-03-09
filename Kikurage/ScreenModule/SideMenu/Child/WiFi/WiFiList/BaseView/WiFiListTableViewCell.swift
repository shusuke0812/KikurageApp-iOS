//
//  WiFiListTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/09.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiListTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        accessoryType = .disclosureIndicator

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        let margin: CGFloat = 16

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin)
        ])
    }

    func updateComponent(title: String) {
        titleLabel.text = title
    }
}
