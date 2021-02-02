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
    private var baseView: MainBaseView { self.view as! MainBaseView } // swiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: MainViewModel!
    /// きくらげの状態
    var kikurageState: KikurageState!
    /// きくらげユーザー
    var kikurageUser: KikurageUser!
    /// タイマー
    private var timer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // ViewModel
        self.viewModel = MainViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUser: self.kikurageUser, kikurageState: self.kikurageState)
        // UI
        self.baseView.setKikurageNameUI(kikurageUser: self.viewModel.kikurageUser)
        self.setNavigationItem()
        // Utility
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
        super.viewWillAppear(animated)
        self.setTimer()
        self.loadKikurageState()
    }
}
// MARK: - Initialized Method
extension MainViewController {
    // ナビゲーションアイテムの設定
    private func setNavigationItem() {
        self.setNavigationBackButton(buttonTitle: "もどる", buttonColor: .black)
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
        self.baseView.delegate = self
    }
}
// MARK: - MainBaseView Delegate Method
extension MainViewController: MainBaseViewDelegate {
    func didTapCultivationButton() {
        // 栽培記録画面へ遷移
        guard let vc = R.storyboard.cultivationViewController.instantiateInitialViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didTapRecipeButton() {
        // 料理記録画面へ遷移
        guard let vc = R.storyboard.recipeViewController.instantiateInitialViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didTapCommunicationButton() {
        // 相談画面へ遷移
        guard let vc = R.storyboard.communicationViewController.instantiateInitialViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didTapSideMenuButton() {
        // サイドメニュー起動
        self.performSegue(withIdentifier: "SideMenu", sender: nil)
    }
}
// MARK: - MainViewModel Delegate Method
extension MainViewController: MainViewModelDelgate {
    // きくらげの状態を取得する
    private func loadKikurageState() {
        self.viewModel.loadKikurageState()
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
}
