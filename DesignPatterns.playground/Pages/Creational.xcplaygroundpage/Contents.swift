//: [Previous](@previous)

import Foundation

/*:
Singleton
------------

The singleton pattern ensures that only one object of a particular class is ever created.
All further references to objects of the singleton class refer to the same underlying instance.
There are very few applications, do not overuse this pattern!

### Example:
*/
class Configuration {
    static let `default` = Singleton()
    
    private init() {
        // Private initialization to ensure just one instance is created.
    }
}
/*:
 ### Usage:
 */
let configuration = Configuration.default

//: [Next](@next)
