//
//  UseCaseResult.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2026/10/15.
//

import Foundation

/// UseCaseの実行結果を表す型
/// successは各UseCaseが任意の型を指定でき、failureはエラーメッセージに統一する
public enum UseCaseResult<Success> {
    case success(Success)
    case failure(String)
}

public typealias UseCaseCompletion<Success> = (UseCaseResult<Success>) -> Void
