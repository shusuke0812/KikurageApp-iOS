//
//  CalendarViewModel.swift
//  KikurageService
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
    public weak var delegate: CalendarViewModelDelegate?
    public let state = CalendarState()

    private let kikurageUserRepository: KikurageUserRepositoryProtocol
    private let loginManager: LoginManager

    private var kikurageUser: KikurageUser?

    public init(kikurageUserRepository: KikurageUserRepositoryProtocol = KikurageUserRepository()) {
        self.kikurageUserRepository = kikurageUserRepository
        loginManager = LoginManager()
    }
}

// MARK: - Setting Data

extension CalendarViewModel {
    private func saveDateComponents() {
        if let cultivationStartDate = kikurageUser?.cultivationStartDate {
            state.cultivationStartDateComponents = DateHelper.getDateComponents(date: cultivationStartDate)
        } else {
            state.cultivationStartDateComponents = DateHelper.getDateComponents()
        }
        // MEMO: カレンダーの表示範囲の終端には、現在時刻ではなく栽培開始日を使用する（develop時代からの既存挙動）
        state.currentDateComponents = state.cultivationStartDateComponents
    }

    private func calcCultivationTerm() {
        let calendar = Calendar.current

        let startDate = calendar.startOfDay(for: kikurageUser?.cultivationStartDate ?? Date())
        let endDate = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        state.cultivationTerm = components.day
    }
}

// MARK: - Firebase Firestore

extension CalendarViewModel {
    /// きくらげユーザーを取得する
    /// - Parameter uid: ユーザーID
    public func loadKikurageUser() {
        guard let userID = loginManager.userID else {
            delegate?.calendarViewModelDidFailedGetKikurageUser(self, with: "error") // TODO: Error型を定義してVCに通知する
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
                self?.delegate?.calendarViewModelDidFailedGetKikurageUser(self!, with: error.description())
            }
        }
    }
}
