//
//  CalendarBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol CalendarBaseViewDelegate: AnyObject {
    /// 閉じるボタンを押した時の処理
    func didTapCloseButton()
}

class CalendarBaseView: UIView {
    @IBOutlet private weak var navigationItem: UINavigationItem!

    weak var delegate: CalendarBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    // MARK: - Action
    @IBAction private func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
}
// MARK: - Initialized
extension CalendarBaseView {
    private func initUI() {
        // タイトル
        self.navigationItem.title = "カレンダー"
    }
}
