//
//  BluetoothParser.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2023/03/15.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

public struct BluetoothParser {
    public static func decodeWiFi(_ jsonString: String) -> WiFi? {
        do {
            guard let jsonData = jsonString.data(using: .utf8) else {
                return nil
            }
            let response = try JSONDecoder().decode(WiFi.self, from: jsonData)
            return response
        } catch {
            return nil
        }
    }

    public static func decodeBluetoothCompletion(_ jsonString: String) -> BluetoothCompletionMessage? {
        do {
            guard let jsonData = jsonString.data(using: .utf8) else {
                return nil
            }
            let response = try JSONDecoder().decode(BluetoothCompletionMessage.self, from: jsonData)
            return response
        } catch {
            return nil
        }
    }

    static func encodeBluetootCommand<T: Encodable>(_ command: T) -> Data? {
        do {
            let response = try JSONEncoder().encode(command)
            return response
        } catch {
            assertionFailure("\(error.localizedDescription)")
            return nil
        }
    }
}
