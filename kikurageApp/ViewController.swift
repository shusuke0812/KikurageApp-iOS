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
    var timer: Timer!
    var timer2: Timer!
    
    /// 時間のテキストを取得するクラス
    let clock = Clock()
    
    //テスト（Firebaseから値を取得する配列）
    var roomArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //温度湿度テキスト、アドバイステキストを隠す
        self.temparatureText.isHidden = true
        self.humidityText.isHidden = true
        self.statusText.isHidden = true
        
        //1秒毎にクラスdisplayClockを呼び出す
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
//       timer.fire()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.displayClock()
        })
        
        // 2秒毎にデータベースへの参照しさ最新のセンサ値を読み込み、キクラゲの表情を表示する
//       timer2 = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(displaySensor), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer2) in
            self.displaySensor()
        })
//       timer2.fire()
//        display2()
  
    }


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
            self.temparatureText.text = "温度:\(getjson["temparature"].intValue)℃"
            self.humidityText.text = "湿度:\(getjson["humidity"].intValue)％"
            
//            self.temparatureText.text = ""
/*
            for (key, _) in getjson.dictionaryValue {
 //               print("key:\(key)\ntemparature:\(getjson[key]["temparature"].stringValue)\ntimenow:\(getjson[key]["timenow"].stringValue)\n")
                self.temparatureText.text = "温度:\(getjson[key]["temparature"].intValue)"
                self.humidityText.text = "湿度:\(getjson[key]["humidity"].intValue)"

            }
 */
            
            //最新の湿度,温度プロパティを更新
            self.humidityNow = getjson["humidity"].intValue
            self.temparatureNow = getjson["temparature"].intValue
//            self.humidityNow = 10
//            self.tempatatureNow = 10

        }, withCancel: nil)
        
        //最新の湿度,温度がゼロである場合、キクラゲの表情を表示させない
        if humidityNow == 0 || temparatureNow == 0 {
            return
        }
        
        self.temparatureText.isHidden = false
        self.humidityText.isHidden = false
        
        //キクラゲの表情を表示する
        displayKikurage()
    }
    
    //さいばい記録画面へ温湿データを渡す
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segueから遷移先のsaibaiViewControllerを取得
        let saibaiViewController: saibaiViewController = segue.destination as! saibaiViewController
        
        saibaiViewController.temparatureTest = self.temparatureNow
    }
 */

//====================================================
/*********  きくらげの状態を画像で表示させる  **************/
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
        
        //画面スクリーンサイズ
//        let screenWidth = self.view.bounds.width
//        let screenHeight = self.view.bounds.height
//        print(screenWidth)
//        print(screenHeight)
        
        //画像のサイズ
//        let imageWidth = imageBad1?.size.width
//        let imageHeight = imageBad1?.size.height
        
        let imageView :UIImageView = UIImageView(image: imageBad1)
        
        let rect = CGRect(x:5,
                          y:10,
                          width:200,
                          height:130)
        imageView.frame = rect
//        imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)

        self.kikurageStatus.addSubview(imageView)
        
//        print(humidity)
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

