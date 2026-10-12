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

protocol DictionaryTwitterViewModelDelegate: AnyObject {
    func dictionaryTwitterViewModelDidSuccessGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel)
    func dictionaryTwitterViewModelDidFailedGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel, with errorMessage: String)
}

class DictionaryTwitterViewModel {
    weak var delegate: DictionaryTwitterViewModelDelegate?
    let state = DictionaryTwitterState()

    private let twitterSearchRepository: TwitterSearchRepositoryProtocol

    init(twitterSearchRepository: TwitterSearchRepositoryProtocol = TwitterSearchRepository()) {
        self.twitterSearchRepository = twitterSearchRepository
    }
}

extension DictionaryTwitterViewModel {
    func loadTweets() {
        let twitterSearchRequest = TwitterSearchRequest(searchWord: "きくらげ", searchCount: 10, maxID: nil, sinceID: nil)
        twitterSearchRepository.getTweets(request: twitterSearchRequest) { [weak self] response in
            switch response {
            case .success(let tweet):
                self?.state.tweets.append(contentsOf: tweet.statuses)
                self?.delegate?.dictionaryTwitterViewModelDidSuccessGetTweets(self!)
            case .failure(let error):
                self?.delegate?.dictionaryTwitterViewModelDidFailedGetTweets(self!, with: error.description())
            }
        }
    }
}
