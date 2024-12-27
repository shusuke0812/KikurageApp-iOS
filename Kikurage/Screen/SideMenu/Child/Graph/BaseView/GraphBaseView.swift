//
//  GraphBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Charts
import UIKit

enum GraphDataType {
    case temperature
    case humidity
}

class GraphBaseView: UIView {
    private var temperatureLabel: UILabel!
    private var humidityLabel: UILabel!
    private var temperatureLineChartView: LineChartView!
    private var humidityLineChartView: LineChartView!

    private var temperatureActivityIndicator: UIActivityIndicatorView!
    private var humidityActivityIndicator: UIActivityIndicatorView!

    private let chartViewHelper = ChartViewHelper()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        temperatureLabel = UILabel()
        temperatureLabel.contentMode = .left
        temperatureLabel.text = R.string.localizable.side_menu_graph_temperature_subtitle()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        humidityLabel = UILabel()
        humidityLabel.contentMode = .left
        humidityLabel.text = R.string.localizable.side_menu_graph_humidity_subtitle()
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false

        temperatureLineChartView = LineChartView()
        temperatureLineChartView.noDataText = ""
        temperatureLineChartView.translatesAutoresizingMaskIntoConstraints = false

        humidityLineChartView = LineChartView()
        humidityLineChartView.noDataText = ""
        humidityLineChartView.translatesAutoresizingMaskIntoConstraints = false

        temperatureActivityIndicator = UIActivityIndicatorView()
        temperatureActivityIndicator.translatesAutoresizingMaskIntoConstraints = false

        humidityActivityIndicator = UIActivityIndicatorView()
        humidityActivityIndicator.translatesAutoresizingMaskIntoConstraints = false

        temperatureLineChartView.addSubview(temperatureActivityIndicator)
        humidityLineChartView.addSubview(humidityActivityIndicator)

        addSubview(temperatureLabel)
        addSubview(humidityLabel)
        addSubview(temperatureLineChartView)
        addSubview(humidityLineChartView)

        NSLayoutConstraint.activate([
            temperatureActivityIndicator.centerYAnchor.constraint(equalTo: temperatureLineChartView.centerYAnchor),
            temperatureActivityIndicator.centerXAnchor.constraint(equalTo: temperatureLineChartView.centerXAnchor),

            humidityActivityIndicator.centerYAnchor.constraint(equalTo: humidityLineChartView.centerYAnchor),
            humidityActivityIndicator.centerXAnchor.constraint(equalTo: humidityLineChartView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            temperatureLineChartView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            temperatureLineChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            temperatureLineChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            temperatureLineChartView.heightAnchor.constraint(equalTo: temperatureLineChartView.widthAnchor, multiplier: 9.0 / 16.0),

            humidityLabel.topAnchor.constraint(equalTo: temperatureLineChartView.bottomAnchor, constant: 40),
            humidityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            humidityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            humidityLineChartView.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 10),
            humidityLineChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            humidityLineChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            humidityLineChartView.heightAnchor.constraint(equalTo: humidityLineChartView.widthAnchor, multiplier: 9.0 / 16.0),
        ])
    }
}

// MARK: - Setting UI

extension GraphBaseView {
    // TODO: 温度・湿度のグラフの体裁を設定する処理が同じなのでまとめたい
    /// 折れ線グラフ描画処理
    /// - Parameters:
    ///   - datas: グラフデータ（Y軸）
    ///   - graphDataType: 温度 or 湿度
    func setLineChartView(datas: [Int], graphDataType: GraphDataType) {
        // ChartDataEntryクラスにデータを反映
        var entrys: [ChartDataEntry] = []
        for (i, data) in datas.enumerated() {
            entrys.append(ChartDataEntry(x: Double(i), y: Double(data)))
        }
        // 閾値線の設定
        let temperatureLimitLine = ChartLimitLine(limit: 20.0)
        let humidityLimitLine = ChartLimitLine(limit: 80.0)
        temperatureLimitLine.lineDashLengths = [4.0]
        humidityLimitLine.lineDashLengths = [4.0]
        // ChartView設定
        switch graphDataType {
        case .temperature:
            let dataSet = LineChartDataSet(entries: entrys, label: "[℃]")
            dataSet.colors = [R.color.subColor()!]
            dataSet.circleColors = [R.color.subColor()!]
            temperatureLineChartView.data = LineChartData(dataSet: dataSet)
            temperatureLineChartView.xAxis.labelPosition = .bottom
            temperatureLineChartView.leftAxis.addLimitLine(temperatureLimitLine)
            temperatureLineChartView.xAxis.valueFormatter = chartViewHelper
        case .humidity:
            let dataSet = LineChartDataSet(entries: entrys, label: "[%]")
            dataSet.colors = [R.color.subColor()!]
            dataSet.circleColors = [R.color.subColor()!]
            humidityLineChartView.data = LineChartData(dataSet: dataSet)
            humidityLineChartView.xAxis.labelPosition = .bottom
            humidityLineChartView.leftAxis.addLimitLine(humidityLimitLine)
            humidityLineChartView.xAxis.valueFormatter = chartViewHelper
        }
    }

    func startGraphActivityIndicators() {
        temperatureActivityIndicator.isHidden = false
        humidityActivityIndicator.isHidden = false

        temperatureActivityIndicator.startAnimating()
        humidityActivityIndicator.startAnimating()
    }

    func stopGraphActivityIndicators() {
        temperatureActivityIndicator.isHidden = true
        humidityActivityIndicator.isHidden = true

        temperatureActivityIndicator.stopAnimating()
        humidityActivityIndicator.stopAnimating()
    }
}
