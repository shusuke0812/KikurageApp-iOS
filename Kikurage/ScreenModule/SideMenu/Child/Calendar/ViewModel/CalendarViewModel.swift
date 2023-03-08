//
//  CalendarViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol CalendarViewModelDelegate: AnyObject {
    func calendarViewModelDidSuccessGetKikurageUser(_ calendarViewModel: CalendarViewModel)
    func calendarViewModelDidFailedGetKikurageUser(_ calendarViewModel: CalendarViewModel, with errorMessage: String)
}

class CalendarViewModel {
    private let kikurageUserRepository: KikurageUserRepositoryProtocol

    weak var delegate: CalendarViewModelDelegate?

    private(set) var kikurageUser: KikurageUser?
    private(set) var cultivationDateComponents: DateComponents
    private(set) var cultivationTerm: Int?

    init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
        self.cultivationDateComponents = DateHelper.getDateComponents()
        self.cultivationTerm = 0
    }
}

// MARK: - Setting Data

extension CalendarViewModel {
    private func saveDateComponents() {
        if let cultivationStartDate = kikurageUser?.cultivationStartDate {
            cultivationDateComponents = DateHelper.getDateComponents(date: cultivationStartDate)
        }
    }
    private func calcCultivationTerm() {
        let calendar = Calendar.current

        let startDate = calendar.startOfDay(for: kikurageUser?.cultivationStartDate ?? Date())
        let endDate = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        cultivationTerm = components.day
    }
}

// MARK: - Firebase Firestore

extension CalendarViewModel {
    /// きくらげユーザーを取得する
    /// - Parameter uid: ユーザーID
    func loadKikurageUser(uid: String) {
        let request = KikurageUserRequest(uid: uid)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.saveDateComponents()
                self?.calcCultivationTerm()
                self?.delegate?.calendarViewModelDidSuccessGetKikurageUser(self!)
            case .failure(let error):
                self?.delegate?.calendarViewModelDidFailedGetKikurageUser(self!, with: error.description())
            }
        }
    }
}
