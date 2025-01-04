//
//  File.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/2.
//

import Foundation

public struct AppVersion {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public init?(versionString: String) {
        guard let versions = versions(versionString) else {
            return nil
        }
        major = versions[0]
        minor = versions[1]
        patch = versions[2]
    }
    
    public var versionString: String {
        "\(major)\(separator)\(minor)\(separator)\(patch)"
    }
    
    // MARK: Comparable

    public static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
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
    
    // MARK: Equatable
    
    public static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
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

fileprivate let separator: Character = "."

fileprivate func versions(_ versionString: String) -> [Int]? {
    let versions = versionString.split(separator: separator).compactMap { Int($0) }
    return (versions.count == 3) ? versions : nil
}
