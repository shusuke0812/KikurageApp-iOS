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
        initUI()
    }
}

// MARK: - Config

extension SideMenuTableViewCell {
    private func initUI() {
        contentView.backgroundColor = .systemGroupedBackground
        iconImageView.tintColor = .black
    }

    func setSideMenuContent(title: String, iconImageName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconImageName)
    }
}
