//
//  KUITweetTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/18.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Kingfisher
import SwiftUI

public struct KUITweetRowProps {
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

public struct KUITweetRow: View {
    private let props: KUITweetRowProps
    private let iconImageWidth: CGFloat = 50

    public init(props: KUITweetRowProps) {
        self.props = props
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                KFImage(props.iconImageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: iconImageWidth, height: iconImageWidth)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color(uiColor: .lightGray), lineWidth: 0.3)
                    )

                VStack(alignment: .leading, spacing: 8) {
                    Text(props.userName)
                        .font(.system(size: 17, weight: .bold))
                    Text(props.createdAtString)
                        .font(.system(size: 17))
                }
            }

            Text(props.tweet)
                .font(.system(size: 17, weight: .light))
        }
        .padding(8)
    }
}

#Preview {
    KUITweetRow(props: KUITweetRowProps(
        userName: "きくらげ栽培botくん",
        createdAtString: "2022/04/03",
        tweet: "今日もきくらげが元気に育っています🍄",
        iconImageURL: nil
    ))
}
