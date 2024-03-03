//
//  KikurageLogger.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/7/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import os

protocol KLoggerProtocol {
    static func className(from filepath: String) -> String
}

extension KLoggerProtocol {
    static func className(from filepath: String) -> String {
        let fileName = filepath.components(separatedBy: "/").last
        return fileName?.components(separatedBy: ".").first ?? ""
    }
}

/**
 *  For getting iPhone/iPad Logs
 * - Usage: KLogmanger.error("\(value, privacy: .public)") → change root user in MacBook  → In terminal, run # log collect --device --start '2022-01-23 16:00:00' --output kikurage.logarchive → open kikurage.logarchive using Console.app → search logs using Bundle ID
 * - Attension: to save log and watch, set  `.public` of OSLogPrivacy with message arg
 */
@available(iOS 14, *)
public struct KLogManager: KLoggerProtocol {
    private enum Config {
        static let subsystem = Bundle.main.bundleIdentifier! + ".klog" // klog means KikurageApp Log
        static let category = "default"
    }

    private static let filter = "🔥"

    private init() {}

    private static func klog(level: OSLogType, file: String, function: String, line: Int, message: String) {
        let logger = os.Logger(subsystem: Config.subsystem, category: Config.category)
        logger.log(level: level, "\(filter): \(className(from: file)).\(function) #\(line): \(message)")
    }

    public static func debug(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        klog(level: .debug, file: file, function: function, line: line, message: message)
    }

    public static func error(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        klog(level: .error, file: file, function: function, line: line, message: message)
    }

    public static func devFatalError(_ message: String) {
        #if DEBUG
            let className = self.className(from: #file)
            let function = #function
            let line = #line
            fatalError("DEBUG: [Fatal] \(className).\(function) #\(line): \(message)")
        #endif
    }
}

@available(*, deprecated, message: "there is KLogManager which is able to use for iOS14 or newer")
public struct KLogger: KLoggerProtocol {
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
            print("DEBUG: " + "\(dateString) [\(logLevel.rawValue.uppercased())] \(className(from: file)).\(function) #\(line): \(message)")
        #endif
    }

    public static func verbose(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .verbose, file: file, function: function, line: line, message: message)
    }

    public static func debug(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .debug, file: file, function: function, line: line, message: message)
    }

    public static func info(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .info, file: file, function: function, line: line, message: message)
    }

    public static func warn(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .warn, file: file, function: function, line: line, message: message)
    }

    public static func error(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .error, file: file, function: function, line: line, message: message)
    }

    public static func devFatalError(_ message: String) {
        #if DEBUG
            let className = self.className(from: #file)
            let function = #function
            let line = #line
            fatalError("DEBUG: [Fatal] \(className).\(function) #\(line): \(message)")
        #endif
    }
}

// MARK: - TimerStamp

private struct DateHelper {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    /// Date型をログに使うString型へ変換する
    static func formatToStringForLog() -> String {
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return dateFormatter.string(from: Date())
    }
}
