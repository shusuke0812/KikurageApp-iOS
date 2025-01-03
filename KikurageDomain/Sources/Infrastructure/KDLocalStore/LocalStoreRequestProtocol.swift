//
//  LocalStoreRequestProtocol.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/3.
//

import Foundation

/**
 * NOTE:
 * When custon login user in UserDefaults,
 * archive and unarchive processing of these data must conform to NSObject and NSSecureCoding protocols
 */
public protocol UserDefaultsRequestProtocol {
    associatedtype Response: NSObject, NSSecureCoding
    
    var key: String { get }
    var saveData: Response? { get }
}
