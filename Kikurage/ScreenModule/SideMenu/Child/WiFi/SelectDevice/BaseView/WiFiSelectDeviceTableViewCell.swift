//
//  WiFiSelectDeviceTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiSelectDeviceTableViewCell: UITableViewCell {
    private let deviceNameLabel = UILabel()
    private let bleServiceNumberLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        accessoryType = .disclosureIndicator

        deviceNameLabel.font = .systemFont(ofSize: 17)
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(deviceNameLabel)

        let margin: CGFloat = 8

        NSLayoutConstraint.activate([
            deviceNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            deviceNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            deviceNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            deviceNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin)
        ])
    }
}
