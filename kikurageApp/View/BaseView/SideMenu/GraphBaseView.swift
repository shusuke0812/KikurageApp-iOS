//
//  GraphBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit
import Charts

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
    func setTemperatureLineChartView(datas: [Int]) {
        var entry: [ChartDataEntry] = []
        for (i, data) in datas.enumerated() {
            entry.append(ChartDataEntry(x: Double(i), y: Double(data)))
        }
        let dataSet = LineChartDataSet(entry)
        self.temperatureLineChartView.data = LineChartData(dataSet: dataSet)
    }
}
