//
//  GraphWeekDataSource.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/10/24.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

/// １週間分の温度・湿度の平均値を格納する型
struct GraphWeekDataSource {
    /// 曜日毎の温度
    var temperature: [Constants.Week: Int]
    /// 曜日毎の湿度
    var humidity: [Constants.Week: Int]
    
    init?(temperature: [Constants.Week: Int], humidity: [Constants.Week: Int]) {
        guard (temperature.count == 7 && humidity.count == 7) else { return nil }
        
        self.temperature = temperature
        self.humidity = humidity
    }
}


