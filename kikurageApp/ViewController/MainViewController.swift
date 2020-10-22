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
    /// BaseView
    private var baseView: MainBaseView { return self.view as! MainBaseView}
    /// ViewModel
    private var viewModel: MainViewModel!
    
    private let clockHelper: ClockHelper = ClockHelper()
    private let kikurageStateHelper: KikurageStateHelper = KikurageStateHelper()
    private var timer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MainViewModel(kikurageStateRepository: KikurageStateRepository())
        self.setDelegateDataSource()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // メモリ節約のため、他ViewControllerに移動する前にタイマーを停止する
        if let timer = self.timer {
            timer.invalidate()
        }
        self.baseView.kikurageStatusView.stopAnimating()
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
        self.baseView.nowTimeLabel.text = clockHelper.display()
        // 1秒毎に現在時刻表示を更新する
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        // 栽培記録・料理記録・みんなに相談画面のナビゲーションバーの戻るボタンを設定
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "もどる", style: .plain, target: nil, action: nil)
    }
    // 時刻表示更新用メソッド
    @objc private func updateTime() {
        self.baseView.nowTimeLabel.text = clockHelper.display()
    }
    // デリゲート登録
    private func setDelegateDataSource() {
        self.viewModel.delegate = self
    }
}

// きくらげ表情の表示
extension MainViewController {
    private func displayKikurageStateImage(type: String) {
        // 2つの画像を交互に表示する処理（アニメーションのSTOPはViewWillDisapperへ記載）
        self.baseView.kikurageStatusView.animationImages = kikurageStateHelper.setStateImage(type: type)
        self.baseView.kikurageStatusView.animationDuration = 1
        self.baseView.kikurageStatusView.animationRepeatCount = 0
        self.baseView.kikurageStatusView.startAnimating()
    }
}

extension MainViewController: MainViewModelDelgate {
    // きくらげの状態を取得する
    private func loadKikurageState() {
        //self.viewModel.loadKikurageState()
    }
    func didSuccessGetKikurageState() {
        print("test")
    }
    func didFailedGetKikurageState(errorMessage: String) {
        print(errorMessage)
    }
    func didChangedKikurageState() {
        // きくらげの状態メッセージを設定
        if let message: String = self.viewModel.kikurageState?.message {
            self.baseView.kikurageStatusLabel.text = message
        }
        // きくらげの表情を設定
        if let judge: String = self.viewModel.kikurageState?.judge {
            self.displayKikurageStateImage(type: judge)
        }
        // 温度湿度を設定
        if let temparature: Int = self.viewModel.kikurageState?.temperature,
           let humidity: Int = self.viewModel.kikurageState?.humidity {
            self.baseView.temparatureTextLabel.text = "\(temparature)"
            self.baseView.humidityTextLabel.text = "\(humidity)"
        }
    }
}
