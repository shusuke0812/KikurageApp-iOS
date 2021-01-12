//
//  SideMenuContentView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class SideMenuContentView: XibView {
    
    @IBOutlet weak var sideMenuContentIconView: UIImageView!
    @IBOutlet weak var sideMenuContentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBoarder
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setBoarder
    }
}

// MARK: - Initialized Method
extension SideMenuContentView {
    private func setBoarder() {
        // Viewの上下に枠線を引く
        self.setFrameBoarder(width: 0.5, color: .lightGray, position: .top)
        self.setFrameBoarder(width: 0.5, color: .lightGray, position: .bottom)
    }
}
