//
//  CalendarViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/19.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDLoginManager
import KDRepository
import KSSDateHelper

public protocol CalendarViewModelDelegate: AnyObject {
    func calendarViewModelDidSuccessGetKikurageUser(_ calendarViewModel: CalendarViewModel)
    func calendarViewModelDidFailedGetKikurageUser(_ calendarViewModel: CalendarViewModel, with errorMessage: String)
}

public class CalendarViewModel {
    public private(set) var cultivationDateComponents: DateComponents
    public private(set) var cultivationTerm: Int?
    public var currentDateComponents: DateComponents {
        DateHelper.getDateComponents()
    }

    public weak var delegate: CalendarViewModelDelegate?

    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager

    private(set) var kikurageUser: KikurageUser?

    public init(kikurageUserRepository: KikurageUserRepositoryProtocol) {
        self.kikurageUserRepository = kikurageUserRepository
        loginManager = LoginManager()
        cultivationDateComponents = DateHelper.getDateComponents()
        cultivationTerm = 0
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
    public func loadKikurageUser() {
        guard let userID = loginManager.userID else {
            delegate?.calendarViewModelDidFailedGetKikurageUser(self, with: "error")
            return
        }
        let request = KikurageUserRequest(uid: userID)
        kikurageUserRepository.getKikurageUser(request: request) { [weak self] response in
            switch response {
            case .success(let kikurageUser):
                self?.kikurageUser = kikurageUser
                self?.saveDateComponents()
                self?.calcCultivationTerm()
                self?.delegate?.calendarViewModelDidSuccessGetKikurageUser(self!)
            case .failure(let error):
                self?.delegate?.calendarViewModelDidFailedGetKikurageUser(self!, with: "error") // TODO: error.description()
            }
        }
    }
}
