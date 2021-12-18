//
//  StubKikurageStateRepository.swift
//  KikurageTests
//
//  Created by Shusuke Ota on 2021/12/18.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
@testable import Kikurage

class StubKikurageStateRepository: KikurageStateRepositoryProtocol {
    private var returnKikurageState: KikurageState
    private var returnKikurageStateGraph: [(graph: KikurageStateGraph, documentId: String)]
    private var argProductId: String?
    
    init(kikurageState: KikurageState, kikurageStateGraph: [(graph: KikurageStateGraph, documentId: String)]) {
        self.returnKikurageState = kikurageState
        self.returnKikurageStateGraph = kikurageStateGraph
    }
    
    // MARK: Call Firebase
    func getKikurageState(productId: String, completion: @escaping (Result<KikurageState, ClientError>) -> Void) {
        self.argProductId = productId
        completion(.success(self.returnKikurageState))
    }
    
    func getKikurageStateGraph(productId: String, completion: @escaping (Result<[(graph: KikurageStateGraph, documentId: String)], ClientError>) -> Void) {
        self.argProductId = productId
        completion(.success(self.returnKikurageStateGraph))
    }
}
