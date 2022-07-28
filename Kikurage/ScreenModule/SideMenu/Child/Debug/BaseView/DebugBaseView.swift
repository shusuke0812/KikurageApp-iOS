//
//  DebugBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol DebugBaseViewDelegate: AnyObject {
    func debugBaseViewDidTappedForceRestrart(_ debugBaseView: DebugBaseView)
    func debugBaseViewDidTappedKonashiFind(_ debugBaseView: DebugBaseView)
}

class DebugBaseView: UIView {
    @IBOutlet private weak var forceRestartButton: UIButton!
    @IBOutlet private weak var konashiFindButton: UIButton!
    @IBOutlet private weak var konashiRSSILabel: UILabel!
    @IBOutlet private weak var konashiPIOLabel: UILabel!

    weak var delegate: DebugBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: Action
    @IBAction private func didTappedForceRestartButton(_ sender: UIButton) {
        delegate?.debugBaseViewDidTappedForceRestrart(self)
    }
    @IBAction private func didTappedKonashiFindButton(_ sender: UIButton) {
        delegate?.debugBaseViewDidTappedKonashiFind(self)
    }
}

// MARK: - Initialized

extension DebugBaseView {
    private func initUI() {
        forceRestartButton.setTitle("Force logout and restart app after 2min", for: .normal)

        konashiFindButton.setTitle("Find Konashi", for: .normal)
        konashiFindButton.layer.masksToBounds = true
        konashiFindButton.layer.cornerRadius = .buttonCornerRadius
        konashiFindButton.tintColor = .white
        konashiFindButton.backgroundColor = .systemBlue

        konashiRSSILabel.text = "RSSI: -"

        konashiPIOLabel.text = "- no PIO signal -"
    }
    func setRSSILabel(_ text: String) {
        konashiRSSILabel.text = "RSSI: " + "\(text)"
    }
    func setPIOLabel(_ text: String) {
        konashiPIOLabel.text = text
    }
}
