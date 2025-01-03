//
//  LoginUser.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/10/2.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

/**
 * NOTE:
 * When custon login user in UserDefaults,
 * archive and unarchive processing of these data must conform to NSObject and NSSecureCoding protocols
 */
public class LoginUser: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true

    public let uid: String
    public let isEmailVerified: Bool

    public init(uid: String, isEmailVerified: Bool) {
        self.uid = uid
        self.isEmailVerified = isEmailVerified
    }

    public required init?(coder: NSCoder) {
        uid = coder.decodeObject(forKey: "uidKey") as! String // swiftlint:disable:this force_cast
        isEmailVerified = coder.decodeBool(forKey: "isEmailVerifiedKey")
    }

    public func encode(with coder: NSCoder) {
        coder.encode(uid, forKey: "uidKey")
        coder.encode(isEmailVerified, forKey: "isEmailVerifiedKey")
    }
}
