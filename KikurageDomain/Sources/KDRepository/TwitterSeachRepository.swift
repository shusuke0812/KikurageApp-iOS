//
//  TwitterSeachRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KDEntity
import KDRestApi

public protocol TwitterSearchRepositoryProtocol {
    func getTweets(request: TwitterSearchRequest, completion: @escaping (Result<Tweet, RestApiClientError>) -> Void)
}

public class TwitterSearchRepository: TwitterSearchRepositoryProtocol {
    private let apiClient: APIClientProtocol

    public init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - API Method

    public func getTweets(request: TwitterSearchRequest, completion: @escaping (Result<Tweet, RestApiClientError>) -> Void) {
        apiClient.sendRequest(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
