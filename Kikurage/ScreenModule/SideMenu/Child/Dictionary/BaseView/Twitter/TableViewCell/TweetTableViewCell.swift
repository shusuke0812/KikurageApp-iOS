//
//  TweetTableViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import SDWebImage

class TweetTableViewCell: UITableViewCell {
    @IBOutlet private weak var userIconImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    @IBOutlet private weak var tweetLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Initialized

extension TweetTableViewCell {
    private func initUI() {
        userIconImageView.clipsToBounds = true
        userIconImageView.layer.cornerRadius = userIconImageView.frame.width / 2
        userIconImageView.layer.borderColor = UIColor.lightGray.cgColor
        userIconImageView.layer.borderWidth = 0.3

        userNameLabel.font = .boldSystemFont(ofSize: 17.0)

        tweetLabel.font = .systemFont(ofSize: 17.0, weight: .light)
    }
}

// MARK: - Setting UI

extension TweetTableViewCell {
    func setUI(tweet: Tweet.Status) {
        userNameLabel.text = tweet.user.name
        createdAtLabel.text = DateHelper.formatToString(date: tweet.createdAt)
        tweetLabel.text = tweet.text
        if let iconImageUrlString = URL(string: tweet.user.profileImageUrl) {
            userIconImageView.sd_setImage(with: iconImageUrlString)
        }
    }
}
