//: [Behavioral](Behavioral) |
//: Creational |
//: [Structural](Structural)
/*:
 Creational
 ==========
 
 > In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or in added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Creational_pattern)
 */
import Swift
import Foundation
/*:
 Singleton
 ----------

The singleton pattern ensures that only one object of a particular class is ever created.
All further references to objects of the singleton class refer to the same underlying instance.
There are very few applications, do not overuse this pattern!

### Example:
*/
enum LogLevel: Int {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
}

enum LogTag: String {
    case observable
    case model
    case viewModel
    case view
}

protocol Loggable {
    static func v(tag: LogTag, message: String)
    static func d(tag: LogTag, message: String)
    static func i(tag: LogTag, message: String)
    static func w(tag: LogTag, message: String)
    static func e(tag: LogTag, message: String)
}

extension Loggable {
    static func v(tag: LogTag, message: String) {
        Logger.default.log(level: .verbose, tag: tag, message: message)
    }
    
    static func d(tag: LogTag, message: String) {
        Logger.default.log(level: .debug, tag: tag, message: message)
    }
    
    static func i(tag: LogTag, message: String) {
        Logger.default.log(level: .info, tag: tag, message: message)
    }
    
    static func w(tag: LogTag, message: String) {
        Logger.default.log(level: .warning, tag: tag, message: message)
    }
    
    static func e(tag: LogTag, message: String) {
        Logger.default.log(level: .error, tag: tag, message: message)
    }
}

class Log: Loggable {}

class Logger {
    static let `default` = Logger()
    
    private init() {
        // Private initialization to ensure just one instance is created.
    }
    
    func log(level: LogLevel, tag: LogTag, message: String) {
        print("\(level.rawValue): ", message)
    }
}
/*:
 ### Usage:
 */
Log.i(tag: .model, message: "info")
