//
//  DictionaryTwitterViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import UIKit.UITableView

protocol DictionaryTwitterViewModelDelegate: AnyObject {
    func dictionaryTwitterViewModelDidSuccessGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel)
    func dictionaryTwitterViewModelDidFailedGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel, with errorMessage: String)
}

class DictionaryTwitterViewModel: NSObject {
    private let twitterSearchRepository: TwitterSearchRepositoryProtocol

    weak var delegate: DictionaryTwitterViewModelDelegate?

    private(set) var tweets: [Tweet.Status] = []

    init(twitterSearchRepository: TwitterSearchRepositoryProtocol) {
        self.twitterSearchRepository = twitterSearchRepository
    }
}

extension DictionaryTwitterViewModel {
    func loadTweets() {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.tweetTableViewCell, for: indexPath) else {
            return UITableViewCell()
        }
        cell.setUI(tweet: tweets[indexPath.row])
        return cell
    }
}
