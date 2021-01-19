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

protocol GraphBaseViewDelegate: class {
    /// 閉じるボタンを押した時の処理
    func didTapCloseButton()
}

class GraphBaseView: UIView {
    
    @IBOutlet weak var navigationItem: UINavigationItem!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLineChartView: LineChartView!
    @IBOutlet weak var humidityLineChartView: LineChartView!
    /// デリゲート
    internal weak var delegate: GraphBaseViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    // MARK: - Action Method
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
}
// MARK: - Initialized Method
extension GraphBaseView {
    private func initUI() {
        // タイトル
        self.navigationItem.title = "グラフ"
        self.temperatureLabel.text = "温度"
        self.humidityLabel.text = "湿度"
    }
}
// MARK: - Setting UI Method
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
        case .humidity:
            let dataSet = LineChartDataSet(values: entrys, label: "[%]")
            dataSet.colors = [.subColor]
            dataSet.circleColors = [.subColor]
            self.humidityLineChartView.data = LineChartData(dataSet: dataSet)
            self.humidityLineChartView.xAxis.labelPosition = .bottom
            self.humidityLineChartView.leftAxis.addLimitLine(humidityLimitLine)
        }
    }
}
