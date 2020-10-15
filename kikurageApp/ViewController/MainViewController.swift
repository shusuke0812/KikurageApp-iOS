//
//  ViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MessageUI

class MainViewController: UIViewController {
   
    @IBOutlet weak var nowTimeLabel: UILabel!
    @IBOutlet weak var kikurageNameLabel: UILabel!
    @IBOutlet weak var kikurageStatusLabel: UILabel!
    @IBOutlet weak var kikurageStatusView: UIImageView!
    @IBOutlet weak var temparatureTextLabel: UILabel!
    @IBOutlet weak var humidityTextLabel: UILabel!
    
    private let clockHelper: ClockHelper = ClockHelper()
    private var timer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // メモリ節約のため、他ViewControllerに移動する前にタイマーを停止する
        if let timer = self.timer {
            timer.invalidate()
        }
        self.kikurageStatusView.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUI()
    }
    // MARK:- Action Method
    @IBAction func didTapCultivationPageButton(_ sender: Any) {
        // さいばい記録画面へ遷移させる
        let s: UIStoryboard = UIStoryboard(name: "CultivationViewController", bundle: nil)
        let vc: CultivationViewController = s.instantiateInitialViewController() as! CultivationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapRecipePageButton(_ sender: Any) {
        // 料理記録画面へ遷移させる
        let s: UIStoryboard = UIStoryboard(name: "RecipeViewController", bundle: nil)
        let vc: RecipeViewController = s.instantiateInitialViewController() as! RecipeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapCommunicationPageButton(_ sender: Any) {
        // みんなに相談画面へ遷移させる
        let s: UIStoryboard = UIStoryboard(name: "CommunicationViewController", bundle: nil)
        let vc: CommunicationViewController = s.instantiateInitialViewController() as! CommunicationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapSideMenuButton(_ sender: Any) {
        // サイドメニューを開く
        self.performSegue(withIdentifier: "SideMenu", sender: nil)
    }
}

// MARK: - Initialized Method
extension MainViewController {
    // UIを初期化する
    private func setUI() {
        // ラベル、画像に初期値を設定する
        self.nowTimeLabel.text = clockHelper.display()
        
        // きくらげ表情の表示
        self.displayKikurageStateImage()
        
        // 1秒毎に現在時刻表示を更新する
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        // 栽培記録・料理記録・みんなに相談画面のナビゲーションバーの戻るボタンを設定
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "もどる", style: .plain, target: nil, action: nil)
    }
    // 時刻表示更新用メソッド
    @objc private func updateTime() {
        self.nowTimeLabel.text = clockHelper.display()
    }
}

// きくらげ表情の表示
extension MainViewController {
    private func displayKikurageStateImage() {
        // TODO：温度湿度によって表情を変える処理を書く
        var kikurageStateImages: [UIImage] = []
        let beforeNormaImage: UIImage = UIImage(named: "normal_01")!
        let afterNormalImage: UIImage = UIImage(named: "normal_02")!
        
        kikurageStateImages.append(beforeNormaImage)
        kikurageStateImages.append(afterNormalImage)
        
        // 2つの画像を交互に表示する処理（アニメーションのSTOPはViewWillDisapperへ記載）
        self.kikurageStatusView.animationImages = kikurageStateImages
        self.kikurageStatusView.animationDuration = 1
        self.kikurageStatusView.animationRepeatCount = 0
        self.kikurageStatusView.startAnimating()
    }
}
