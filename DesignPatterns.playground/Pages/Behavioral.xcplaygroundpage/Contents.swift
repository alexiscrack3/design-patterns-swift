//: Behavioral |
//: [Creational](Creational) |
//: [Structural](Structural)
/*:
 Behavioral
 ==========
 
 >In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Behavioral_pattern)
 */
import Swift
import Foundation
/*:
 Observer
 ----------
 
 The observer pattern is used to allow an object to publish changes to its state.
 Other objects subscribe to be immediately notified of any changes.
 
 ### Example
 */
protocol Observable {
    var observers: Array<Observer> { get }
    
    func attach(observer: Observer)
    func detach(observer: Observer)
    func notify()
}

class Product: Observable {
    var id: String = UUID().uuidString
    
    var inStock = false {
        didSet {
            notify()
        }
    }
    
    var observers: Array<Observer> = []
    
    func attach(observer: Observer) {
        observers.append(observer)
    }
    
    func detach(observer: Observer) {
        if let index = observers.index(where: { ($0 as! Product).id == (observer as! Product).id }) {
            observers.remove(at: index)
        }
    }
    
    func notify() {
        for observer in observers {
            observer.getNotification(inStock)
        }
    }
}

protocol Observer {
    func getNotification(_ inStock: Bool)
}

class User: Observer {
    func getNotification(_ inStock: Bool) {
        print("Is product available? \(inStock)")
    }
}
/*:
 ### Usage
 */
let foo = User()
let bar = User()

let shorts = Product()
shorts.attach(observer: foo)
shorts.attach(observer: bar)

shorts.inStock = true
/*:
 Strategy
 ----------
    
The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

### Example
*/
class SaveFileDialog {
    private let strategy: Strategy
    
    init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    func save(_ fileName: String) {
        let path = strategy.save(fileName)
        print("Saved in \(path)")
    }
}

protocol Strategy {
    func save(_ fileName: String) -> String
}

class DocFileStrategy: Strategy {
    func save(_ fileName: String) -> String {
        return "\(fileName).doc"
    }
}

class TextFileStrategy: Strategy {
    func save(_ fileName: String) -> String {
        return "\(fileName).txt"
    }
}
/*:
 ### Usage
 */
let docFile = SaveFileDialog(strategy: DocFileStrategy())
docFile.save("file")

let textFile = SaveFileDialog(strategy: TextFileStrategy())
textFile.save("file")
