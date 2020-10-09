//
//  SideMenuContentView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol SideMenuContentViewDelegate: class {
    func transitonSideMenuContent(view: SideMenuContentView)
}

class SideMenuContentView: XibView {
    @IBOutlet weak var sideMenuContentIconView: UIImageView!
    @IBOutlet weak var sideMenuContentLabel: UILabel!
    
    internal weak var delegate: SideMenuContentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    // MARK: - Action Method
    @IBAction func didTapSideMenuContent(_ sender: Any) {
        self.delegate?.transitonSideMenuContent(view: self)
    }
}

// MARK: - Initialized Method
extension SideMenuContentView {
    private func setUI() {
        // Viewの上下に枠線を引く
        self.setFrameBoarder(width: 0.5, color: .lightGray, position: .top)
        self.setFrameBoarder(width: 0.5, color: .lightGray, position: .bottom)
    }
}
