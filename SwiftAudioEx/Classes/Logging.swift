//
//  Logging.swift
//  SwiftAudioEx
//
//  Created by Andrej Slegl on 14/03/2023.
//

import Foundation

public protocol SwiftAudioLoggerProtocol {
    func log(_ text: String, file: StaticString, line: UInt)
}

extension SwiftAudioLoggerProtocol {
    func log(_ text: String, file: StaticString = #filePath, line: UInt = #line) {
        log(text, file: file, line: line)
    }
}

public struct SwiftAudioLogger {
    public static func set(shared: SwiftAudioLoggerProtocol) {
        Logger.shared = shared
    }
}

struct Logger {
    fileprivate(set) static var shared: SwiftAudioLoggerProtocol = DummyLogger()
}

class DummyLogger: SwiftAudioLoggerProtocol {
    func log(_ text: String, file: StaticString, line: UInt) { }
}
