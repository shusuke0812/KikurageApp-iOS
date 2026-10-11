//
//  DictionaryTwitterViewModel.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import KDRepository
import KSSDateHelper

@_exported import KDEntity

public protocol DictionaryTwitterViewModelDelegate: AnyObject {
    func dictionaryTwitterViewModelDidSuccessGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel)
    func dictionaryTwitterViewModelDidFailedGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel, with errorMessage: String)
}

public class DictionaryTwitterViewModel {
    public weak var delegate: DictionaryTwitterViewModelDelegate?
    public let state = DictionaryTwitterState()

    private let twitterSearchRepository: TwitterSearchRepositoryProtocol

    public init(twitterSearchRepository: TwitterSearchRepositoryProtocol = TwitterSearchRepository()) {
        self.twitterSearchRepository = twitterSearchRepository
    }
}

extension DictionaryTwitterViewModel {
    public func loadTweets() {
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
