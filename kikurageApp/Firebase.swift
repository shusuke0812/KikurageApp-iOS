//
//  Firebase.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/04/06.
//  Copyright © 2019 shusuke. All rights reserved.
//
/*
import Foundation

//Firebase追加
import Firebase
import SwiftyJSON
import FirebaseAuth

class Firebase {
    
    //Firebaseから取得するリアルタイム湿度,温度を保存するプロパティ
    var humidity :Int = 0
    var tempatature :Int = 0
    
    //テスト（Firebaseから値を取得する配列）
    var roomArray: Array<String> = []
    
    //現在の温度、湿度表示
    var temparatureText :String = ""
    var humidityText :String = ""
    
    
    //====================================================
    /****  Firebaseからリアルタイムで温度湿度の値を読み込む  ****/
    //====================================================
    
    //累積データ/////////////////////////
    func display2() {
        //Databaseの参照URLを取得
        let ref = Database.database().reference()
        //        print("----------")
        //        print(ref)
        //データ取得開始
        ref.child("kikurage_user1").child("monitor").observeSingleEvent(of: .value) { (snap, error) in
            //RoomList下の階層をまとめて取得
            let snapdata = snap.value as? [String:NSDictionary]
            
            //データを取得する配列
            self.roomArray = [String]()
            //もしデータがなければ無反応
            if snapdata == nil {
                return
            }
            //snapdata!.keys : 階層
            //key : 階層
            for key in snapdata!.keys.sorted() {
                //snap : 階層下のデータを書くのすいた辞書
                let snap = snapdata![key]
                if let roomname = snap!["temparature"] as? String {
                    self.roomArray.append(roomname)
                    //                    print(self.roomArray)
                }
            }
        }
    }
    
    
    
    //スナップショットデータ////////////////
    @objc func displaySensor() {
        
        let ref = Database.database().reference()
        
        //トレーリングクロージャ？
        ref.child("kikurage_user1").child("monitor2").observeSingleEvent(of: .value, with:{(snapshot) in
            /*
             if let data = snapshot.value as? [String:AnyObject] {
             let temparature = data["temparature"] as? Double
             //                self.temparatureText.text = temparature
             print(temparature)
             }
             */
            let getjson = JSON(snapshot.value as? [String : AnyObject] ?? [:])
            if getjson.count == 0 {
                return
            }
            self.temparatureText = "温度:\(getjson["temparature"].intValue)℃"
            self.humidityText = "湿度:\(getjson["humidity"].intValue)％"
            
            //            self.temparatureText.text = ""
            /*
             for (key, _) in getjson.dictionaryValue {
             //               print("key:\(key)\ntemparature:\(getjson[key]["temparature"].stringValue)\ntimenow:\(getjson[key]["timenow"].stringValue)\n")
             self.temparatureText.text = "温度:\(getjson[key]["temparature"].intValue)"
             self.humidityText.text = "湿度:\(getjson[key]["humidity"].intValue)"
             
             }
             */
            
            //最新の湿度,温度プロパティを更新
            self.humidity = getjson["humidity"].intValue
            self.tempatature = getjson["temparature"].intValue
            //            self.humidityNow = 10
            //            self.tempatatureNow = 10
            
        }, withCancel: nil)
        
        //最新の湿度,温度がゼロである場合、キクラゲの表情を表示させない
        if humidity == 0 || tempatature == 0 {
            return
        }

    }

    
}
 */
