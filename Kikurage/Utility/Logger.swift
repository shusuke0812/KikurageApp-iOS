//
//  Logger.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/9/16.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

struct Logger {
    private static var dateString: String = DateHelper.formatToStringForLog()

    enum LogLevel: String {
        case verbose
        case debug
        case info
        case warn
        case error
    }

    private static func printToConsole(logLevel: LogLevel, file: String, function: String, line: Int, message: String) {
        #if DEBUG
        print("DEBUG: " + "\(dateString) [\(logLevel.rawValue.uppercased())] \(self.className(from: file)).\(function) #\(line): \(message)")
        #endif
    }

    private static func className(from filepath: String) -> String {
        let fileName = filepath.components(separatedBy: "/").last
        return fileName?.components(separatedBy: ".").first ?? ""
    }

    static func verbose(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .debug, file: file, function: function, line: line, message: message)
    }

    static func debug(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .debug, file: file, function: function, line: line, message: message)
    }

    static func info(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .info, file: file, function: function, line: line, message: message)
    }

    static func warn(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .warn, file: file, function: function, line: line, message: message)
    }

    static func error(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .error, file: file, function: function, line: line, message: message)
    }
}
