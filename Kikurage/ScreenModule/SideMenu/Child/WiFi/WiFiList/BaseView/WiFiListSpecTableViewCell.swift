//
//  WiFiListSpecTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/09.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KikurageFeature
import UIKit

class WiFiListSpecTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let stateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        selectionStyle = .none

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        stateLabel.font = .systemFont(ofSize: 17)
        stateLabel.text = "-"
        stateLabel.textColor = .gray
        stateLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(stateLabel)

        let margin: CGFloat = 16

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),

            stateLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            stateLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: margin),
            stateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            stateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin)
        ])
    }

    func updateComponent(title: String) {
        titleLabel.text = title
    }

    func updateComponent(stateTitle: String) {
        stateLabel.text = stateTitle
    }
}
