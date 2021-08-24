//
//  GraphBaseView.swift
//  kikurageApp
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

protocol GraphBaseViewDelegate: AnyObject {
    /// 閉じるボタンを押した時の処理
    func didTapCloseButton()
}

class GraphBaseView: UIView {
    @IBOutlet private weak var navigationItem: UINavigationItem!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var temperatureLineChartView: LineChartView!
    @IBOutlet private weak var humidityLineChartView: LineChartView!
    /// デリゲート
    weak var delegate: GraphBaseViewDelegate?
    /// ChartViewHelper
    private let chartViewHelper = ChartViewHelper()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    // MARK: - Action
    @IBAction private func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
}
// MARK: - Initialized
extension GraphBaseView {
    private func initUI() {
        // タイトル
        self.navigationItem.title = "グラフ"
        self.temperatureLabel.text = "温度"
        self.humidityLabel.text = "湿度"
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
            let dataSet = LineChartDataSet(values: entrys, label: "[℃]")
            dataSet.colors = [.subColor]
            dataSet.circleColors = [.subColor]
            self.temperatureLineChartView.data = LineChartData(dataSet: dataSet)
            self.temperatureLineChartView.xAxis.labelPosition = .bottom
            self.temperatureLineChartView.leftAxis.addLimitLine(temperatureLimitLine)
            self.temperatureLineChartView.xAxis.valueFormatter = chartViewHelper
        case .humidity:
            let dataSet = LineChartDataSet(values: entrys, label: "[%]")
            dataSet.colors = [.subColor]
            dataSet.circleColors = [.subColor]
            self.humidityLineChartView.data = LineChartData(dataSet: dataSet)
            self.humidityLineChartView.xAxis.labelPosition = .bottom
            self.humidityLineChartView.leftAxis.addLimitLine(humidityLimitLine)
            self.humidityLineChartView.xAxis.valueFormatter = chartViewHelper
        }
    }
}
