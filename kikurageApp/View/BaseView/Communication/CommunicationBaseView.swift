//
//  CommunicationBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol CommunicationBaseViewDelegate: AnyObject {
    /// Facebookボタンを押した時の処理
    func didTapFacebookButton()
}

class CommunicationBaseView: UIView {
    @IBOutlet weak var informationLabel: UILabel!
    /// デリゲート
    weak var delegate: CommunicationBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    // MARK: - Action
    @IBAction private func didTapFacebookButton(_ sender: Any) {
        self.delegate?.didTapFacebookButton()
    }
}
// MARK: - Initialized
extension CommunicationBaseView {
    private func initUI() {
        self.informationLabel.text = """
        【お知らせ】
        キクラゲ栽培者同士でお互いに相談できるFacebookグループです。Facebookアカウントを持っていない方は下記ボタンのリンク先の「新しいアカウントを作成」より設定してください。
        """
        self.informationLabel.backgroundColor = .information
    }
}
