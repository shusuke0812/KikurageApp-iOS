//
//  CommunicationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol CommunicationBaseViewDelegate: AnyObject {
    func communicationBaseViewDidTapFacebookButton(_ communicationBaseView: CommunicationBaseView)
}

class CommunicationBaseView: UIView {
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var informationParentView: UIView!

    weak var delegate: CommunicationBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action

    @IBAction private func openFacebook(_ sender: Any) {
        delegate?.communicationBaseViewDidTapFacebookButton(self)
    }
}

// MARK: - Initialized

extension CommunicationBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        informationLabel.text = R.string.localizable.screen_communication_information()

        informationParentView.clipsToBounds = true
        informationParentView.layer.cornerRadius = .viewCornerRadius
    }
}
