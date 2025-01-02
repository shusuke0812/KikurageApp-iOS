//
//  File.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/2.
//

import Foundation

public enum LocalStoreError: Error {
    case notFound
    case failedToDecode
    case failedToEncode
}
