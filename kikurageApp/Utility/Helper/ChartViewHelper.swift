//
//  ChartViewHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import Charts

/// Chartsのx軸を設定するヘルパー
class ChartViewHelper: NSObject, IAxisValueFormatter {
    let xAxisValues = ["月曜", "火曜", "水曜", "木曜", "金曜", "土曜", "日曜"]

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        return xAxisValues[index]
    }
}
