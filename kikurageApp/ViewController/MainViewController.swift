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
    
    /// 時間のテキストを取得するクラス
    private let clockHelper: ClockHelper = ClockHelper()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // 1秒毎に現在時刻表示を更新する
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
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
        /*
         imageView.animationDuration = 1 //間隔（秒）
         imageView.animationRepeatCount = 100 //繰り返し
         imageView.startAnimating()
         */
    }
}
