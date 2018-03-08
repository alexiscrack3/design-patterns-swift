//: [Previous](@previous)

import Foundation

/*:
Strategy
-----------
    
The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

### Example
*/
final class Dialog {
    private let strategy: SaveStrategy
    
    func save(_ path: String) -> String {
        return self.strategy.save(path)
    }
    
    init(strategy: SaveStrategy) {
        self.strategy = strategy
    }
}

protocol SaveStrategy {
    func save(_ path: String) -> String
}

final class TextFileStrategy: SaveStrategy {
    func save(_ path: String) -> String {
        return "\(path)/file.txt"
    }
}

final class DocFileStrategy: SaveStrategy {
    func save(_ path: String) -> String {
        return "\(path)/file.doc"
    }
}
/*:
 ### Usage
 */
var textFile = Dialog(strategy: TextFileStrategy())
textFile.save("~/Desktop")

var docFile = Dialog(strategy: DocFileStrategy())
docFile.save("~/Desktop")

//: [Next](@next)
