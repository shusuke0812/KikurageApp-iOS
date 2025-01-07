//
//  DictionaryTwitterViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDRepository
import KSFeatures
import KUIKit
import UIKit.UITableView

public protocol DictionaryTwitterViewModelDelegate: AnyObject {
    func dictionaryTwitterViewModelDidSuccessGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel)
    func dictionaryTwitterViewModelDidFailedGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel, with errorMessage: String)
}

public class DictionaryTwitterViewModel: NSObject {
    public private(set) var tweets: [Tweet.Status] = []

    public weak var delegate: DictionaryTwitterViewModelDelegate?

    private let twitterSearchRepository: TwitterSearchRepositoryProtocol

    public init(twitterSearchRepository: TwitterSearchRepositoryProtocol) {
        self.twitterSearchRepository = twitterSearchRepository
    }
}

extension DictionaryTwitterViewModel {
    public func loadTweets() {
        let twitterSearchRequest = TwitterSearchRequest(searchWord: "きくらげ", searchCount: 10, maxID: nil, sinceID: nil)
        twitterSearchRepository.getTweets(request: twitterSearchRequest) { [weak self] response in
            switch response {
            case .success(let tweet):
                self?.tweets.append(contentsOf: tweet.statuses)
                self?.delegate?.dictionaryTwitterViewModelDidSuccessGetTweets(self!)
            case .failure(let error):
                self?.delegate?.dictionaryTwitterViewModelDidFailedGetTweets(self!, with: error.description())
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension DictionaryTwitterViewModel: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KUITweetTableViewCell.identifier, for: indexPath) as! KUITweetTableViewCell // swiftlint:disable:this force_cast
        let tweet = tweets[indexPath.row]
        cell.updateItem(props: KUITweetTableViewCellProps(
            userName: tweet.user.name,
            createdAtString: DateHelper.formatToString(date: tweet.createdAt),
            tweet: tweet.text,
            iconImageURL: URL(string: tweet.user.profileImageURL)
        ))
        return cell
    }
}
