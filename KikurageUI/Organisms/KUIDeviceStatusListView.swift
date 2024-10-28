//
//  KUIDeviceStatusListView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/29.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIDeviceStatusListViewProps {
    let temperature: Int
    let humidity: Int
    let backgroundColor: UIColor?

    public init(temperature: Int, humidity: Int, backgroundColor: UIColor?) {
        self.temperature = temperature
        self.humidity = humidity
        self.backgroundColor = backgroundColor
    }
}

public class KUIDeviceStatusListView: UIView {
    private var temperatureLabel: UILabel!
    private var humidityLabel: UILabel!

    private var temperature: Int
    private var humidity: Int

    private let temperatureUnit = "°C"
    private let humidityUnit = "%"

    public init(props: KUIDeviceStatusListViewProps) {
        temperature = props.temperature
        humidity = props.humidity
        super.init(frame: .zero)

        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    public func updateStatus(temperature: Int, humidity: Int) {
        self.temperature = temperature
        self.humidity = humidity
    }

    private func setupComponent(props: KUIDeviceStatusListViewProps) {
        backgroundColor = props.backgroundColor

        let columnStackView = createColumnView()
        columnStackView.translatesAutoresizingMaskIntoConstraints = false

        let columnTemperatureStackView = createTemperatureView()
        columnTemperatureStackView.translatesAutoresizingMaskIntoConstraints = false

        let columnHumidityStackView = createHumidityView()
        columnHumidityStackView.translatesAutoresizingMaskIntoConstraints = false

        let topDivider = KUIDividerView()
        topDivider.translatesAutoresizingMaskIntoConstraints = false

        let bottomDivider = KUIDividerView()
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false

        let contentView = KUIRoundedView(props: KUIRoundedViewProps())
        contentView.backgroundColor = props.backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(columnStackView)
        contentView.addSubview(columnTemperatureStackView)
        contentView.addSubview(columnHumidityStackView)
        contentView.addSubview(topDivider)
        contentView.addSubview(bottomDivider)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            // Content
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Parts
            topDivider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            topDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            topDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            columnStackView.topAnchor.constraint(equalTo: topDivider.bottomAnchor, constant: 8),
            columnStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            columnStackView.trailingAnchor.constraint(equalTo: columnTemperatureStackView.leadingAnchor, constant: -50),
            columnStackView.bottomAnchor.constraint(equalTo: bottomDivider.topAnchor, constant: -8),

            columnTemperatureStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            columnTemperatureStackView.trailingAnchor.constraint(equalTo: columnHumidityStackView.leadingAnchor, constant: -50),

            columnHumidityStackView.topAnchor.constraint(equalTo: contentView.topAnchor),

            bottomDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bottomDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bottomDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    private func createColumnView() -> UIStackView {
        let actualLabel = UILabel()
        actualLabel.text = "現在" // TODO: R.Swiftに置き換える
        actualLabel.font = .systemFont(ofSize: 15)

        let expectedLabel = UILabel()
        expectedLabel.text = "理想" // TODO: R.Swiftに置き換える
        expectedLabel.font = .systemFont(ofSize: 15)

        let stackView = UIStackView(arrangedSubviews: [actualLabel, expectedLabel])
        stackView.axis = .vertical
        stackView.spacing = 15

        return stackView
    }

    private func createTemperatureView() -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.text = "温度" // TODO: R.Swiftに置き換える

        temperatureLabel = UILabel()
        temperatureLabel.font = .systemFont(ofSize: 15, weight: .bold)
        temperatureLabel.text = "\(temperature)"

        let expectedLabel = UILabel()
        expectedLabel.font = .systemFont(ofSize: 15)
        expectedLabel.text = "20-25" + temperatureUnit

        let stackView = UIStackView(arrangedSubviews: [titleLabel, temperatureLabel, expectedLabel])
        stackView.axis = .vertical
        stackView.spacing = 12

        return stackView
    }

    private func createHumidityView() -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.text = "湿度" // TODO: R.Swiftに置き換える

        humidityLabel = UILabel()
        humidityLabel.font = .systemFont(ofSize: 15, weight: .bold)
        humidityLabel.text = "\(temperature)"

        let expectedLabel = UILabel()
        expectedLabel.font = .systemFont(ofSize: 15)
        expectedLabel.text = "80" + humidityUnit + "以上" // TODO: R.Swiftに置き換える

        let stackView = UIStackView(arrangedSubviews: [titleLabel, humidityLabel, expectedLabel])
        stackView.axis = .vertical
        stackView.spacing = 12

        return stackView
    }
}
