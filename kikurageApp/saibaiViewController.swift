//
//  saibaiViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import Charts

class saibaiViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var pictureLabel: UILabel!
    @IBOutlet weak var observationDate: UILabel!
    @IBOutlet weak var observationWrite: UITextView!
    @IBOutlet weak var observationLabel: UILabel!
    
    var chart: CombinedChartView!
    var lineDataSet: LineChartDataSet!
    
    /// 時間のテキストを取得するクラス
    let clock = Clock()
    
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
        
        //リストを作り、グラフのデータを追加する方法（GitHubにあったCombinedChartViewとかMPAndroidChartのwikiを参考にしている********************
        let values: [Double] = [0, 254, 321, 512, 214, 444, 967, 101, 765, 228,
                                726, 253, 20, 123, 512, 448, 557, 223, 465, 291,
                                979, 134, 864, 481, 405, 711, 1106, 411, 455, 761]
        let values2: [Double] = [190,203,210,420,520,620,720,820,920,200,
                                 201,220,203,420,520,657,757,857,579,570,
                                 571,572,573,574,575,576,577,578,579,571]
        let date : [Double] = [1,2,3,4,5,6,7,8,9,10,
                               11,12,13,14,15,16,17,18,19,20,
                               21,22,23,24,25,26,27,28,29,30]
        let date2 : [Double] = [1,3,5,7,9,14,16,17,18,20,
                                21,24,25,26,27,28,29,30,32,36,
                                40,41,42,43,44,45,46,47,48,49]
        
        
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
        
        //データを送るためのDataSet変数をリストで作る
        var linedata:  [LineChartDataSet] = Array()
        
        //リストにデータを入れるためにデータを成形している
        //データの数値と名前を決める
        lineDataSet = LineChartDataSet(values: entries, label: "温度")
        lineDataSet.drawIconsEnabled = false
        
        //グラフの線の色とマルの色を変えている********************
        lineDataSet.colors = [NSUIColor.gray]
        lineDataSet.circleColors = [NSUIColor.gray]
        //上で作ったデータをリストにappendで入れる
        linedata.append(lineDataSet)
        
        //上に同じ
        lineDataSet = LineChartDataSet(values: entries2, label: "湿度")
        lineDataSet.drawIconsEnabled = false
        lineDataSet.colors = [NSUIColor.black]
        lineDataSet.circleColors = [NSUIColor.black]
        linedata.append(lineDataSet)
        
        
        //データを返す。今回のデータは複数なのでdataSetsになる
        return LineChartData(dataSets: linedata)
    }
    
    

}
