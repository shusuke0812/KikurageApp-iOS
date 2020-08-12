//
//  saibaiViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import Charts

//Firebase追加
import Firebase
import SwiftyJSON
import FirebaseAuth

class saibaiViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var pictureLabel: UILabel!
    @IBOutlet weak var observationDate: UILabel!
    @IBOutlet weak var observationWrite: UITextView!
    @IBOutlet weak var observationLabel: UILabel!
    
    var chart: CombinedChartView!
    var lineDataSet: LineChartDataSet!
    
    /// 時間のテキストを取得するクラス
    let clock = ClockHelper()
    
    //テスト（Firebaseから値を取得する配列）
    var roomArrayTemparature: Array<Int> = []
    var roomArrayHumidity: Array<Int> = []
    var temparatureTest: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //観察日を取得する
        observationDate.text = clock.display()
        observationDate.adjustsFontSizeToFitWidth = true //文字サイズ自動調整
        
        //combinedDataを結合グラフに設定する
        let combinedData = CombinedChartData()
        
        //結合グラフに線グラフのデータ読み出し
        combinedData.lineData = generateLineData()
        
        //グラフのサイズ設定、座標設定********************
        //        chart = CombinedChartView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width , height:         self.view.frame.height - 20))
        chart = CombinedChartView(frame: CGRect(x: 0, y: 110, width: self.view.frame.width , height: 190))
        
        //chartのデータにcombinedDataを挿入する
        chart.data = combinedData
        
        //chartを出力（グラフをスクロールビューに配置）
        self.view.addSubview(chart)
        
        /*TextView起動時のキーボードに終了ボタン「Done」を追加する*/
        //「Done」を押すとなぜか止まる？？？
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(saibaiViewController.commitButtonTapped))
        
        kbToolBar.items = [spacer, commitButton]
        observationWrite.inputAccessoryView = kbToolBar
        
        //UITextViewのプレースホルダーを隠す
/*       if self.observationWrite.text != nil {
            self.observationLabel.isHidden = true
        }
 */
        
    }
 
    
    @objc func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    
//====================================================
/*********  カメラできくらげの栽培記録をとる  **************/
//====================================================
    
    //撮影が終わった時に呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey :Any]) {
        
        //撮影した写真を配置したpicture imageに渡す
        cameraView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    //「カメラを起動する」ボタンをタップした時の処理
    @IBAction func cameraButtonAction(_ sender: Any) {
        
        //カメラが利用可能かチェックする
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("カメラは利用できます")
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion:  nil)
            
            //「写真」表記を消す
            pictureLabel.isHidden = true
        }
        else {
            print("カメラは利用できません")
        }
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
            self.roomArrayTemparature = [Int]()
            //もしデータがなければ無反応
            if snapdata == nil {
                return
            }
            //snapdata!.keys : 階層
            //key : 階層
            for key in snapdata!.keys.sorted() {
                //snap : 階層下のデータを書くのすいた辞書
                let snap = snapdata![key]
                if let roomname = snap!["temparature"] as? Int {
                    self.roomArrayTemparature.append(roomname)
                    //                    print(self.roomArray)
                }
                else if let roomname = snap!["humidity"] as? Int {
                    self.roomArrayHumidity.append(roomname)
                }
            }
        }
    }
  
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        textField.resignFirstResponder()
//        return true
//    }
    
    @IBAction func diarySaveButton(_ sender: Any) {
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
//====================================================
/*********  グラフを作成するメソッド  **************/
//====================================================
    
    func generateLineData() -> LineChartData
    {
        //display2()
        //リストを作り、グラフのデータを追加する方法（GitHubにあったCombinedChartViewとかMPAndroidChartのwikiを参考にしている********************

        let values: [Double] = [20, 26, 22, 23, 23, 24, 20, 11, 10, 30,
                                20, 21, 25, 23, 27, 28, 15, 15, 19, 22,
                                30, 27, 22, 26]
 
        /*
        let values: [Double] = [Double(self.temparatureTest), 26, 22, 23, 23, 24, 20, 11, 10, 30,
                                20, 21, 25, 23, 27, 28, 15, 15, 19, 22,
                                30, 27, 22, 26]
 */
        
        let values2: [Double] = [40,42,45,42,49,50,55,54,58,58,
                                 56,60,62,65,67,68,69,73,77,78,
                                 80,84,83,81]
 
        let date : [Double] = [1,2,3,4,5,6,7,8,9,10,
                               11,12,13,14,15,16,17,18,19,20,
                               21,22,23,24]
        let date2 : [Double] = [1,2,3,4,5,6,7,8,9,10,
                                11,12,13,14,15,16,17,18,19,20,
                                21,22,23,24]
        
        
        //DataSetを行うために必要なEntryの変数を作る　データによって入れるデータが違うため複数のentriesが必要になる？
        //多分、データ毎にappendまでをしていくことによってentriesを少なくすることはできると思う
        var entries: [ChartDataEntry] = Array()
        for (i, value) in values.enumerated(){
            entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
        var entries2: [ChartDataEntry] = Array()
        for (i, value) in values2.enumerated(){
            entries2.append(ChartDataEntry(x: date2[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
        
        //グラフテスト
/*        var entries: [ChartDataEntry] = Array()
        for (i, value) in roomArrayTemparature.enumerated(){
            entries.append(ChartDataEntry(x: date[i], y: Double(value), icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
        var entries2: [ChartDataEntry] = Array()
        for (i, value) in roomArrayHumidity.enumerated(){
            entries2.append(ChartDataEntry(x: date2[i], y: Double(value), icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
*/
        
        //データを送るためのDataSet変数をリストで作る
        var linedata:  [LineChartDataSet] = Array()
        
        //リストにデータを入れるためにデータを成形している
        //データの数値と名前を決める
        lineDataSet = LineChartDataSet(values: entries, label: "温度")
        lineDataSet.drawIconsEnabled = false
        
        //グラフの線の色とマルの色を変えている********************
        lineDataSet.colors = [NSUIColor.red]
        lineDataSet.circleColors = [NSUIColor.red]
        //上で作ったデータをリストにappendで入れる
        linedata.append(lineDataSet)
        
        //上に同じ
        lineDataSet = LineChartDataSet(values: entries2, label: "湿度")
        lineDataSet.drawIconsEnabled = false
        lineDataSet.colors = [NSUIColor.blue]
        lineDataSet.circleColors = [NSUIColor.blue]
        linedata.append(lineDataSet)
        
        
        //データを返す。今回のデータは複数なのでdataSetsになる
        return LineChartData(dataSets: linedata)
    }
    
    

}
