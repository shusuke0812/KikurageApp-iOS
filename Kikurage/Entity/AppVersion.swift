//
//  AppVersion.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/27.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

struct AppVersion {
    let major: Int
    let minor: Int
    let patch: Int
    
    init?(versionString: String) {
        guard let versions = versions(versionString) else {
            return nil
        }
        self.major = versions[0]
        self.minor = versions[1]
        self.patch = versions[2]
    }
    
    var versionString: String {
        return "\(major)\(separator)\(minor)\(separator)\(patch)"
    }
    
    static var currentAppVersion: AppVersion {
        guard let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("can not read app version")
        }
        return AppVersion(versionString: versionString) ?? { fatalError("can not create app version") }()
    }
}

// MARK: - Comparable

extension AppVersion: Comparable {
    static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major < rhs.major {
            return true
        } else if lhs.major > rhs.major {
            return false
        }
        
        if lhs.minor < rhs.minor {
            return true
        } else if lhs.minor > rhs.minor {
            return false
        }
        
        if lhs.patch < rhs.patch {
            return true
        }
        
        return false
    }
}

// MARK: - Equatable

extension AppVersion: Equatable {
    static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major == rhs.major {
            return true
        } else if lhs.minor == rhs.minor {
            return true
        } else if lhs.patch == rhs.patch {
            return true
        }
        return false
    }
}

// MARK: - Private

private let separator: Character = "."

private func versions(_ versionString: String) -> [Int]? {
    let versions = versionString.split(separator: separator).compactMap { Int($0) }
    return (versions.count == 3) ? versions : nil
}
