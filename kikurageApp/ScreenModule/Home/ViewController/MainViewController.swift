//
//  ViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import MessageUI

class MainViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: MainBaseView { self.view as! MainBaseView } // swiftlint:disable:this force_cast
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
        viewModel = MainViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageUser: kikurageUser, kikurageState: kikurageState)
        baseView.setKikurageNameUI(kikurageUser: viewModel.kikurageUser)
        setNavigationItem()
        setDelegateDataSource()
        adjustNavigationBarBackgroundColor()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // メモリ節約のため、他ViewControllerに移動する前にタイマーを停止する
        if let timer = self.timer {
            timer.invalidate()
        }
        baseView.kikurageStatusView.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTimer()
        loadKikurageState()
    }
}
// MARK: - Initialized
extension MainViewController {
    private func setNavigationItem() {
        setNavigationBackButton(buttonTitle: "もどる", buttonColor: .black)
    }
    private func setTimer() {
        // 1秒毎に現在時刻表示を更新する
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    @objc private func updateUI() {
        baseView.updateTimeLabel()
    }
    private func setDelegateDataSource() {
        viewModel.delegate = self
        baseView.delegate = self
    }
}
// MARK: - MainBaseView Delegate
extension MainViewController: MainBaseViewDelegate {
    func didTapCultivationButton() {
        // 栽培記録画面へ遷移
        guard let vc = R.storyboard.cultivationViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    func didTapRecipeButton() {
        guard let vc = R.storyboard.recipeViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    func didTapCommunicationButton() {
        guard let vc = R.storyboard.communicationViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    func didTapSideMenuButton() {
        performSegue(withIdentifier: "SideMenu", sender: nil)
    }
}
// MARK: - MainViewModel Delegate
extension MainViewController: MainViewModelDelgate {
    private func loadKikurageState() {
        viewModel.loadKikurageState()
    }
    func didSuccessGetKikurageState() {
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
    }
    func didFailedGetKikurageState(errorMessage: String) {
        print(errorMessage)
    }
    func didChangedKikurageState() {
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
    }
}
