//
//  SideMenuContentView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class SideMenuContentView: XibView {
    @IBOutlet private weak var sideMenuContentIconView: UIImageView!
    @IBOutlet private weak var sideMenuContentLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// MARK: - Setting UI
extension SideMenuContentView {
    /// Viewの上下に枠線を引く
    /// - Parameters:
    ///   - topWidth: 上枠線の幅
    ///   - bottomWidth: 下枠線の幅
    func setBoarder(topWidth: CGFloat?, bottomWidth: CGFloat?) {
        if let topWidth = topWidth {
            setFrameBoarder(width: topWidth, color: .lightGray, position: .top)
        }
        if let bottomWidth = bottomWidth {
            setFrameBoarder(width: bottomWidth, color: .lightGray, position: .bottom)
        }
    }
    func setSideMenuContent(title: String, imageSystemName: String) {
        sideMenuContentLabel.text = title
        sideMenuContentIconView.image = UIImage(systemName: imageSystemName)
    }
}
