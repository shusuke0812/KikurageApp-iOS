//
//  PostCultivationViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostCultivationViewModelDelegate: class {
    /// 栽培記録の投稿に成功した
    func didSuccessPostCultivation()
    /// 栽培記録の投稿に失敗した
    func didFailedPostCultivation(errorMessage: String)
}
class PostCultivationViewModel {
    /// 栽培記録リポジトリ
    private let cultivationRepository: CultivationRepositoryProtocol
    /// デリゲート
    internal weak var delegate: PostCultivationViewModelDelegate?
    
    init(cultivationRepository: CultivationRepositoryProtocol) {
        self.cultivationRepository = cultivationRepository
    }
}
// MARK: - Firebase Method
extension PostCultivationViewModel {
    func postCultivation(kikurageUserId: String,
                         kikurageCultivation: KikurageCultivation) {
        self.cultivationRepository
            .postCultivation(kikurageUserId: kikurageUserId, kikurageCultivation: kikurageCultivation, completion: { response in
                switch response {
                case .success(let documentReference):
                    print(documentReference)
                    self.delegate?.didSuccessPostCultivation()
                case .failure(let error):
                    print("DEBUG: \(error)")
                    self.delegate?.didFailedPostCultivation(errorMessage: "DEBUG: 栽培記録データの投稿に失敗しました")
                }
            })
    }
}
