//
//  ChartViewHelper.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Charts
import Foundation

/// Chartsのx軸を設定するヘルパー
class ChartViewHelper: NSObject, AxisValueFormatter {
    let xAxisValues = Constants.Week.allCases

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // MEMO: Index out of range対策（参考：https://github.com/danielgindi/Charts/issues/1749）
        let index = Int(value) % xAxisValues.count
        return xAxisValues[index].localizedString
    }
}
