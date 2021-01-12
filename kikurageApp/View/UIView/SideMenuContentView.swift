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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// MARK: - Setting UI Method
extension SideMenuContentView {
    /// Viewの上下に枠線を引く
    /// - Parameters:
    ///   - topWidth: 上枠線の幅
    ///   - bottomWidth: 下枠線の幅
    func setBoarder(topWidth: CGFloat?, bottomWidth: CGFloat?) {
        if let topWidth = topWidth {
            self.setFrameBoarder(width: topWidth, color: .lightGray, position: .top)
        }
        if let bottomWidth = bottomWidth {
            self.setFrameBoarder(width: bottomWidth, color: .lightGray, position: .bottom)
        }
    }
    func setSideMenuContent(title: String, imageSystemName: String) {
        self.sideMenuContentLabel.text = title
        self.sideMenuContentIconView.image = UIImage(systemName: imageSystemName)
    }
}
