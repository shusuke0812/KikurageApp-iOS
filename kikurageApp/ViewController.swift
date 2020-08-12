//
//  ViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

//Firebase追加
import Firebase
import SwiftyJSON
import FirebaseAuth

//Mailer追加
import MessageUI

class ViewController: UIViewController {
   
    @IBOutlet weak var nowTime: UILabel!
    @IBOutlet weak var kikurageStatus: UIImageView!
    @IBOutlet weak var temparatureText: UILabel!
    @IBOutlet weak var humidityText: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var adviceText: UILabel!
    
   
    //Firebaseから取得するリアルタイム湿度,温度を保存するプロパティ
    var humidityNow :Int = 0
    var temparatureNow :Int = 0
    
    //現在時刻を取得するためのタイマーを設定する
    var timerClock: Timer!
    var timerDisplay: Timer!
    
    /// 時間のテキストを取得するクラス
    let clock = Clock()
    
    //テスト（Firebaseから値を取得する配列）
    var roomArray: Array<String> = []
    
    //Firebaseデータ取得用
    var ref: DatabaseReference!
    
//====================================================
/****  画面表示  ****/
//====================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //温度湿度テキスト、アドバイステキストを隠す :ok
        self.temparatureText.isHidden = true
        self.humidityText.isHidden = true
        self.statusText.isHidden = true
        
        //博士コメントの枠を装飾 :ok
        adviceText.layer.borderColor = UIColor.red.cgColor
        adviceText.layer.borderWidth = 0.5
        adviceText.layer.cornerRadius = 10.0
        adviceText.layer.masksToBounds = true
        
        //1秒毎にクラスdisplayClockを呼び出す：ok
        timerClock = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timerClock) in
            self.displayClock()
        })
        
        // 2秒毎にデータベースへの参照し、最新のセンサ値を読み込み、キクラゲの表情を表示する :ok
        timerDisplay = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timerDisplay) in
            self.displaySensor()
        })
  
    }


//====================================================
/****  Firebaseからリアルタイムで温度湿度の値を読み込む  ****/
//====================================================

//累積データ///////////////////////// ボツ：Firebaseのデータ保存容量制限を回避するため、データは更新する方針とする
    func display2() {
        //Databaseの参照URLを取得
        ref = Database.database().reference()

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
                }
            }
        }
    }

    

//スナップショットデータ////////////////
    @objc func displaySensor() {
        
        //Firebaseインスタンス取得
        ref = Database.database().reference()
        
        //monitor2内で値が変更されたとき、クロージャー関数がコールバックされる
        ref.child("kikurage_user1").child("monitor2").observe(DataEventType.value, with:{(snapshot) in

           let getjson = JSON(snapshot.value as? [String : AnyObject] ?? [:])
           if getjson.count == 0 {
                return
            }
            self.temparatureText.text = "温度:\(getjson["temparature"].intValue)℃"
            self.humidityText.text = "湿度:\(getjson["humidity"].intValue)％"
            
            //最新の湿度,温度プロパティを更新
            self.humidityNow = getjson["humidity"].intValue
            self.temparatureNow = getjson["temparature"].intValue
            
            print("DEBUG: check2")

        }, withCancel: nil)
        
        self.temparatureText.isHidden = false
        self.humidityText.isHidden = false
        
        print("DEBUG_humidityNow:\(humidityNow)")
        print("DEBUG_temparatureNow:\(temparatureNow)")
        //最新の湿度,温度がゼロである場合、キクラゲの表情を表示させない
        if humidityNow == 0 || temparatureNow == 0 {
            print("DEBUG:温度・湿度に値がありません")
            return
        }
        
        //キクラゲの表情を表示する
        displayKikurage()
    }

//====================================================
/*********  きくらげ栽培環境を画像で表示させる  ************/
//====================================================
    func displayKikurage() {
        
        //きくらげ表情
        let imageBad1 = UIImage(named: "Dry-1")
        let imageBad2 = UIImage(named: "Dry-2")
        let imageGood1 = UIImage(named: "Normal-1")
        let imageGood2 = UIImage(named: "Normal-2")
        
        var imageListArrayBad :Array<UIImage> = []
        var imageListArrayGood :Array<UIImage> = []
        
        imageListArrayBad.append(imageBad1!)
        imageListArrayBad.append(imageBad2!)
        
        imageListArrayGood.append(imageGood1!)
        imageListArrayGood.append(imageGood2!)
        
        let imageView :UIImageView = UIImageView(image: imageBad1)
        
        let rect = CGRect(x:5,
                          y:10,
                          width:200,
                          height:130)
        imageView.frame = rect

        self.kikurageStatus.addSubview(imageView)

        //湿度によって表情を変える
        if humidityNow <= 80 && humidityNow >= 60 {
            if temparatureNow >= 20 && temparatureNow <= 25 {
                imageView.animationImages = imageListArrayGood
                self.statusText.text = "ノリノリやで！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\n引き続き見守っているのじゃぞ！"
            }
            else if temparatureNow > 25 {
                imageView.animationImages = imageListArrayGood
                self.statusText.text = "ちょっと暑いけど、大丈夫だよ！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\n乾燥してしまうかもしれんぞ。\n涼しいところにキクラゲを移動させるのじゃ！"
            }
            else {
                imageView.animationImages = imageListArrayGood
                self.statusText.text = "寒いよー。暖かくして！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\nすこし暖かいところにキクラゲを移動させるのじゃ。\n水やりは控えるとよいぞ。"
            }
        }
        else if humidityNow > 80 {
            if temparatureNow >= 20 && temparatureNow <= 25 {
                imageView.animationImages = imageListArrayBad
                self.statusText.text = "もうおなかいっぱいや！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\n水をあげすぎてしまったようじゃ。\n換気の良いところへ移動して元気にするのじゃぞ！"
            }
            else if temparatureNow > 25 {
                imageView.animationImages = imageListArrayBad
                self.statusText.text = "暑いし、もうおなかいっぱいや！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\n水をあげすぎてしまったようじゃ。\n涼しい場所へ移動し休ませるのじゃ！"
            }
            else {
                imageView.animationImages = imageListArrayBad
                self.statusText.text = "おなかいっぱいだし、寒いなー！"
                self.statusText.isHidden = false
                self.statusText.adjustsFontSizeToFitWidth = true
                self.adviceText.text = "（きくらげ博士より）\n水の上げすぎじゃ。\nカビが生えてしまうぞ！暖かい所へ移動させるのじゃ！"
            }
        }
        else {
            if temparatureNow >= 20 && temparatureNow <= 25 {
                imageView.animationImages = imageListArrayBad
                self.statusText.text = "のどカラカラや！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\nおなかが空いているようじゃ。\n水をあげるのじゃ！！"
            }
            else if temparatureNow > 25 {
                imageView.animationImages = imageListArrayBad
                self.statusText.text = "暑いけど、おなかすいたー！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\n水をあげて涼しいところへ移動させるのじゃ。"
            }
            else {
                imageView.animationImages = imageListArrayBad
                self.statusText.text = "寒いし、おなかすいたなー！"
                self.statusText.isHidden = false
                self.adviceText.text = "（きくらげ博士より）\n水をあげて暖かいところへ移動させるのじゃ。"
            }
        }
        
        imageView.animationDuration = 1 //間隔（秒）
        imageView.animationRepeatCount = 100 //繰り返し
        imageView.startAnimating()
    }
    
//====================================================
/*********  現在時刻を取得する  **************/
//====================================================
    @objc func displayClock() {
        nowTime.text = clock.display()
    }
}

