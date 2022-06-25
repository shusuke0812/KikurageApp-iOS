//
//  StubKikurageStateRepository.swift
//  KikurageTests
//
//  Created by Shusuke Ota on 2021/12/18.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import RxSwift
@testable import Kikurage

class StubKikurageStateRepository: KikurageStateRepositoryProtocol {
    private var returnKikurageState: KikurageState
    private var returnKikurageStateGraph: [KikurageStateGraphTuple]
    
    init(kikurageState: KikurageState, kikurageStateGraph: [KikurageStateGraphTuple]) {
        self.returnKikurageState = kikurageState
        self.returnKikurageStateGraph = kikurageStateGraph
    }
}

// MARK: - Call Firebase

extension StubKikurageStateRepository {
    func getKikurageState(request: KikurageStateRequest, completion: @escaping (Result<KikurageState, ClientError>) -> Void) {
        completion(.success(self.returnKikurageState))
    }

    func getKikurageStateGraph(request: KiikurageStateGraphRequest, completion: @escaping (Result<[KikurageStateGraphTuple], ClientError>) -> Void) {
        completion(.success(self.returnKikurageStateGraph))
    }
    
    func getKikurageState(request: KikurageStateRequest) -> Single<KikurageState> {
        Single<KikurageState>.create { [weak self] single in
            if let `self` = self {
                single(.success(self.returnKikurageState))
            }
            return Disposables.create()
        }
    }
}
