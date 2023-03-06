//
//  WiFiSelectDeviceTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/03/06.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit
import KikurageFeature

class WiFiSelectDeviceTableViewCell: UITableViewCell {
    private let bleSignalImageView = UIImageView()
    private let bleSignalLabel = UILabel()
    private let deviceNameLabel = UILabel()
    private let bleServiceCountLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupComponent() {
        accessoryType = .disclosureIndicator

        bleSignalImageView.image = KikurageBluetoothSignal().image
        bleSignalImageView.translatesAutoresizingMaskIntoConstraints = false

        bleSignalLabel.text = "-"
        bleSignalLabel.font = .systemFont(ofSize: 12)

        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .center
        leftStackView.addArrangedSubview(bleSignalImageView)
        leftStackView.addArrangedSubview(bleSignalLabel)
        leftStackView.translatesAutoresizingMaskIntoConstraints = false

        deviceNameLabel.font = .systemFont(ofSize: 20)
        deviceNameLabel.text = "Unnamed"

        bleServiceCountLabel.font = .systemFont(ofSize: 17)
        bleServiceCountLabel.textColor = .gray
        bleServiceCountLabel.text = "No services"

        let rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.addArrangedSubview(deviceNameLabel)
        rightStackView.addArrangedSubview(bleServiceCountLabel)
        rightStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(leftStackView)
        addSubview(rightStackView)

        let margin: CGFloat = 8
        let imageSize: CGFloat = 24

        NSLayoutConstraint.activate([
            bleSignalImageView.widthAnchor.constraint(equalToConstant: imageSize),
            bleSignalImageView.heightAnchor.constraint(equalToConstant: imageSize),

            leftStackView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin * 2),
            leftStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            leftStackView.widthAnchor.constraint(equalToConstant: imageSize * 1.5),

            rightStackView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor, constant: margin * 2),
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin * 2),
            rightStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin)
        ])
    }

    func updateComponent(peripheral: KikurageBluetoothPeripheral) {
        let signal = KikurageBluetoothSignal.getSignal(rssi: peripheral.rssiInt)
        bleSignalImageView.image = signal.image

        bleSignalLabel.text = peripheral.rssiString
        deviceNameLabel.text = peripheral.deviceName
        bleServiceCountLabel.text = peripheral.serviceCountString
    }
}
