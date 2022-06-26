//
//  GraphBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import Charts

enum GraphDataType {
    case temperature
    case humidity
}

class GraphBaseView: UIView {
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var temperatureLineChartView: LineChartView!
    @IBOutlet private weak var humidityLineChartView: LineChartView!

    @IBOutlet private weak var temperatureActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var humidityActivityIndicator: UIActivityIndicatorView!

    private let chartViewHelper = ChartViewHelper()

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

// MARK: - Initialized

extension GraphBaseView {
    private func initUI() {
        // タイトル
        temperatureLabel.text = R.string.localizable.side_menu_graph_temperature_subtitle()
        humidityLabel.text = R.string.localizable.side_menu_graph_humidity_subtitle()
        // 背景色
        backgroundColor = .systemGroupedBackground
        // グラフ
        temperatureLineChartView.noDataText = ""
        humidityLineChartView.noDataText = ""
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
            dataSet.colors = [.subColor]
            dataSet.circleColors = [.subColor]
            temperatureLineChartView.data = LineChartData(dataSet: dataSet)
            temperatureLineChartView.xAxis.labelPosition = .bottom
            temperatureLineChartView.leftAxis.addLimitLine(temperatureLimitLine)
            temperatureLineChartView.xAxis.valueFormatter = chartViewHelper
        case .humidity:
            let dataSet = LineChartDataSet(entries: entrys, label: "[%]")
            dataSet.colors = [.subColor]
            dataSet.circleColors = [.subColor]
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
