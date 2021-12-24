//
//  CommunicationBaseView.swift
//  Kikurage
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
    @IBOutlet weak var informationParentView: UIView!
    
    weak var delegate: CommunicationBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    // MARK: - Action
    @IBAction private func didTapFacebookButton(_ sender: Any) {
        delegate?.didTapFacebookButton()
    }
}
// MARK: - Initialized
extension CommunicationBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground
        
        informationLabel.text = R.string.localizable.screen_communication_information()
        
        informationParentView.clipsToBounds = true
        informationParentView.layer.cornerRadius = 18
    }
}
