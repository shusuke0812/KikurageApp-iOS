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
}

class DebugBaseView: UIView {
    @IBOutlet weak var forceRestartButton: UIButton!

    weak var delegate: DebugBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: Action
    @IBAction private func didTappedForceRestartButton(_ sender: UIButton) {
        delegate?.debugBaseViewDidTappedForceRestrart(self)
    }
}

// MARK: - Initialized

extension DebugBaseView {
    private func initUI() {
        forceRestartButton.setTitle("Force logout and restart app after 2min", for: .normal)
    }
}
