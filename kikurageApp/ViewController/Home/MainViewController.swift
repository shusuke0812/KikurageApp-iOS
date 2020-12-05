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
    /// タイマー
    private var timer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MainViewModel(
            kikurageStateRepository: KikurageStateRepository(),
            kikurageUserRepository: KikurageUserRepository())
        self.setDelegateDataSource()
        self.loadKikurageUser()
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
        self.setTimer()
        self.loadKikurageState()
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
    // ナビゲーションアイテムの設定
    private func setNavigationItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "もどる", style: .plain, target: nil, action: nil)
    }
    // タイマーの設定
    private func setTimer() {
        // 1秒毎に現在時刻表示を更新する
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    // タイマーによってUIを更新
    @objc private func updateUI() {
        self.baseView.updateTimeLabel()
    }
    // デリゲート登録
    private func setDelegateDataSource() {
        self.viewModel.delegate = self
    }
}
// MARK: - Delegate Method
extension MainViewController: MainViewModelDelgate {
    // きくらげの状態を取得する
    private func loadKikurageState() {
        self.viewModel.loadKikurageState()
    }
    private func loadKikurageUser() {
        self.viewModel.loadKikurageUser()
    }
    // きくらげの状態取得可否によってViewの表示をする
    func didSuccessGetKikurageState() {
        self.baseView.setKikurageStateUI(kikurageState: self.viewModel.kikurageState)
    }
    func didFailedGetKikurageState(errorMessage: String) {
        print(errorMessage)
    }
    func didChangedKikurageState() {
        self.baseView.setKikurageStateUI(kikurageState: self.viewModel.kikurageState)
    }
    func didSuccessGetKikurageUser() {
        self.baseView.setKikurageNameUI(kikurageUser: self.viewModel.kikurageUser)
    }
    func didFailedGetKikurageUser(errorMessage: String) {
        print(errorMessage)
    }
}
