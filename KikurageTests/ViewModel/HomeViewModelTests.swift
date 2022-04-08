//
//  KikurageStateRepositoryTests.swift
//  KikurageTests
//
//  Created by Shusuke Ota on 2021/12/18.
//  Copyright © 2021 shusuke. All rights reserved.
//

import XCTest
@testable import Kikurage

class HomeViewModelTests: XCTestCase {
    
    private var kikurageStateRepository: KikurageStateRepositoryProtocol!
    private var homeViewModel: HomeViewModel!

    override func setUpWithError() throws {
        
        // Stub
        
        let testKikurageState = Stub.kikurageState
        let testKikurageUser = Stub.kikurageUser
        let testKikurageStateGraph: [(graph: KikurageStateGraph, documentId: String)] = []
        
        // Repository / ViewModel
        
        kikurageStateRepository = StubKikurageStateRepository(kikurageState: testKikurageState, kikurageStateGraph: testKikurageStateGraph)
        homeViewModel = HomeViewModel(kikurageUser: testKikurageUser, kikurageStateRepository: kikurageStateRepository, kikurageStateListenerRepository: KikurageStateListenerRepository())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // testXXX()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

// MARK: - XXX

extension HomeViewModelTests {
    // ViewModelのロジックテストを書く
    /*
    func testXXX() {
        homeViewModel.XXX()
     
        // MARK: Test flow
        // given
     
        // when
     
        // then
    }
    */
}
