//
//  TwitterSeachRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol TwitterSearchRepositoryProtocol {
    func getTweets(request: TwitterSearchRequest, completion: @escaping (Result<Tweet, ClientError>) -> Void)
}

class TwitterSearchRepository: TwitterSearchRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - API Method

    func getTweets(request: TwitterSearchRequest, completion: @escaping (Result<Tweet, ClientError>) -> Void) {
        apiClient.sendRequest(request) { result in
            switch result {
            case let .success(response):
                completion(.success(response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
