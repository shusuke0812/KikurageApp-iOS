//
//  WiFiListSettingTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/25.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

class WiFiSettingTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let textField = UITextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        selectionStyle = .none

        let fontSize: CGFloat = 17

        titleLabel.font = .systemFont(ofSize: fontSize)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        textField.borderStyle = .none
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel) // You have to add component on contentView, because it can not be tapped textField in case of adding on cell's view.
        contentView.addSubview(textField)

        let margin: CGFloat = 16

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            titleLabel.widthAnchor.constraint(equalToConstant: fontSize * 5),

            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: margin),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
    }

    func updateComponent(title: String) {
        titleLabel.text = title
    }

    func onTextField() {
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension WiFiSettingTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        true
    }
}
