//
//  KikurageStateRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//
protocol KikurageStateRepositoryProtocol {
    func readKikurageState(uid: String, kikurageState: KikurageState)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
}

extension KikurageStateRepository {
    func readKikurageState(uid: String, kikurageState: KikurageState) {
    }
}
