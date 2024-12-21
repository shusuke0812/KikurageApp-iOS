//
//  KUITweetTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/18.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SDWebImage
import UIKit

public struct KUITweetTableViewCellProps {
    let userName: String
    let createdAtString: String
    let tweet: String
    let iconImageURL: URL?

    public init(userName: String, createdAtString: String, tweet: String, iconImageURL: URL?) {
        self.userName = userName
        self.createdAtString = createdAtString
        self.tweet = tweet
        self.iconImageURL = iconImageURL
    }
}

public class KUITweetTableViewCell: UITableViewCell {
    public static let identifier = "TweetTableViewCell"

    private var userIconImageView: UIImageView!
    private var userNameLabel: UILabel!
    private var createdAtLabel: UILabel!
    private var tweetLabel: UILabel!

    private let iconImageWidth: CGFloat = 50

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateItem(props: KUITweetTableViewCellProps) {
        userNameLabel.text = props.userName
        createdAtLabel.text = props.createdAtString
        tweetLabel.text = props.tweet
        userIconImageView.sd_setImage(with: props.iconImageURL)
    }

    private func setupComponent() {
        userIconImageView = UIImageView()
        userIconImageView.clipsToBounds = true
        userIconImageView.layer.cornerRadius = iconImageWidth / 2
        userIconImageView.layer.borderColor = UIColor.lightGray.cgColor
        userIconImageView.layer.borderWidth = 0.3
        userIconImageView.translatesAutoresizingMaskIntoConstraints = false

        userNameLabel = UILabel()
        userNameLabel.font = .boldSystemFont(ofSize: 17.0)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        createdAtLabel = UILabel()
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(createdAtLabel)

        let headerStackView = UIStackView()
        headerStackView.axis = .horizontal
        headerStackView.alignment = .fill
        headerStackView.distribution = .fill
        headerStackView.spacing = 6
        headerStackView.addArrangedSubview(userIconImageView)
        headerStackView.addArrangedSubview(stackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false

        tweetLabel = UILabel()
        tweetLabel.font = .systemFont(ofSize: 17.0, weight: .light)
        tweetLabel.contentMode = .left
        tweetLabel.numberOfLines = 0
        tweetLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerStackView)
        contentView.addSubview(tweetLabel)

        NSLayoutConstraint.activate([
            userIconImageView.heightAnchor.constraint(equalToConstant: iconImageWidth),
            userIconImageView.widthAnchor.constraint(equalToConstant: iconImageWidth),

            headerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            tweetLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 8),
            tweetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tweetLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tweetLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
