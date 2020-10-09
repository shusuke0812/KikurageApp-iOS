//
//  Clock.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/23.
//  Copyright © 2019 shusuke. All rights reserved.
//

import Foundation

class ClockHelper {
    internal func display() -> String {
        //現在時刻を取得する
        let now = Date()
        
        //Date関数の値を翻訳し、翻訳の型を決める
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        
        //翻訳してもらった値を「時刻ボタン」へ反映する
        return formatter.string(from: now)
    }
}
