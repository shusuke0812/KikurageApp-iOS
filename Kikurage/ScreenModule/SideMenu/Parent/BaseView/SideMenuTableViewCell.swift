//
//  SideMenuTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/20.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessibilityIdentifier = "SideMenuTableViewCell"
    }
}

// MARK: - Config

extension SideMenuTableViewCell {
    func setSideMenuContent(title: String, iconImageName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconImageName)
    }
}
