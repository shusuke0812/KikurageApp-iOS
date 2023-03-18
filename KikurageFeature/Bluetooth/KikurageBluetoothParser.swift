//
//  KikurageBluetoothDecoder.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/03/15.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public struct KikurageBluetoothParser {
    public static func decodeWiFi(_ jsonString: String) -> KikurageWiFi? {
        do {
            guard let jsonData = jsonString.data(using: .utf8) else {
                return nil
            }
            let response = try JSONDecoder().decode(KikurageWiFi.self, from: jsonData)
            return response
        } catch {
            assertionFailure("\(error.localizedDescription)")
        }
        return nil
    }

    public static func encodeBluetootCommand(_ command: BluetoothCommand) -> Data? {
        do {
            let response = try JSONEncoder().encode(command)
            return response
        } catch {
            assertionFailure("\(error.localizedDescription)")
            return nil
        }
    }
}
