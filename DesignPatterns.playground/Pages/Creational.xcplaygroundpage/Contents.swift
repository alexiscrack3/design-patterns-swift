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
 Abstract Factory
 -----------------
 
 The abstract factory pattern is used to provide a client with a set of related or dependant objects.
 The "family" of objects created by the factory are determined at run-time.
 
 ### Example
 */
protocol Sedan {
    func drive()
}

class CompactSedan: Sedan {
    func drive() {
        print("drive a compact sedan")
    }
}

class FullSizeSedan: Sedan {
    func drive() {
        print("drive a full-size sedan")
    }
}

protocol Hatchback {
    func drive()
}

class CompactHatchback: Hatchback {
    func drive() {
        print("drive a compact SUV")
    }
}

class FullSizeHatchback: Hatchback {
    func drive() {
        print("drive a full-size SUV")
    }
}

protocol Factory {
    func produceSedan() -> Sedan
    func produceHatchback() -> Hatchback
}

class CompactCarsFactory: Factory {
    func produceSedan() -> Sedan{
        return CompactSedan()
    }
    func produceHatchback() -> Hatchback {
        return CompactHatchback()
    }
}

class FullSizeCarsFactory: Factory {
    func produceSedan() -> Sedan {
        return FullSizeSedan()
    }
    func produceHatchback() -> Hatchback {
        return FullSizeHatchback()
    }
}
/*:
 ### Usage
 */
let compactCarsFactory = CompactCarsFactory()
let compactSedan = compactCarsFactory.produceSedan()
let compactHatchback = compactCarsFactory.produceHatchback()
compactSedan.drive()
compactHatchback.drive()

let fullSizeCarsFactory = FullSizeCarsFactory()
let fullsizeSedan = fullSizeCarsFactory.produceSedan()
let fullsizeHatchback = fullSizeCarsFactory.produceHatchback()
fullsizeSedan.drive()
fullsizeHatchback.drive()
/*:
 Builder
 ----------
 
 The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm.
 An external class controls the construction algorithm.
 
 ### Example
 */
class Shop {
    func build(builder: VehicleBuilder) -> Vehicle {
        return builder.build()
    }
}

protocol VehicleBuilder {
    var frame: String? { get }
    var engine: String? { get }
    var wheels: Int? { get }
    var doors: Int? { get }
    
    func setFrame(_ frame: String) -> VehicleBuilder
    func setEngine(_ engine: String) -> VehicleBuilder
    func setWheels(_ frame: Int) -> VehicleBuilder
    func setDoors(_ frame: Int) -> VehicleBuilder
    func build() -> Vehicle
}

class CarBuilder: VehicleBuilder {
    var frame: String?
    var engine: String?
    var wheels: Int?
    var doors: Int?
    
    func setFrame(_ frame: String) -> VehicleBuilder {
        self.frame = frame
        return self
    }
    
    func setEngine(_ engine: String) -> VehicleBuilder {
        self.engine = engine
        return self
    }
    
    func setWheels(_ wheels: Int) -> VehicleBuilder {
        self.wheels = wheels
        return self
    }
    
    func setDoors(_ doors: Int) -> VehicleBuilder {
        self.doors = doors
        return self
    }
    
    func build() -> Vehicle {
        return Vehicle(frame: self.frame ?? "", engine: self.engine ?? "", wheels: self.wheels ?? 0, doors: self.doors ?? 0)
    }
}

class MotorcycleBuilder: VehicleBuilder {
    var frame: String?
    var engine: String?
    var wheels: Int?
    var doors: Int?
    
    func setFrame(_ frame: String) -> VehicleBuilder {
        self.frame = "Motorcycle - " + frame
        return self
    }
    
    func setEngine(_ engine: String) -> VehicleBuilder {
        self.engine = "Motorcycle - " + engine
        return self
    }
    
    func setWheels(_ wheels: Int) -> VehicleBuilder {
        self.wheels = wheels
        return self
    }
    
    func setDoors(_ doors: Int) -> VehicleBuilder {
        self.doors = doors
        return self
    }
    
    func build() -> Vehicle {
        return Vehicle(frame: self.frame ?? "", engine: self.engine ?? "", wheels: self.wheels ?? 0, doors: self.doors ?? 0)
    }
}

struct Vehicle {
    var frame: String
    var engine: String
    var wheels: Int
    var doors: Int
}
/*:
 ### Usage: Chained builder
 */
let car = CarBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)
    .build()
print(car)
/*:
 ### Usage: Using a director
 */
let motorcycleBuilder = MotorcycleBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)

let motorcycle = Shop().build(builder: motorcycleBuilder)
print(motorcycle)
/*:
 Factory Method
 ---------------
 
 The factory pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.
 
 ### Example
 */

protocol Shoe {
    var price: Double { get set }
    var weight: Float { get set }
    var type: String { get set }
}

protocol Ball {
    var price: Double { get set }
}

struct RunningShoe: Shoe {
    var price: Double
    var weight: Float
    var type: String
}

struct SoccerBall: Ball {
    var price: Double
}

struct BasketballBall: Ball {
    var price: Double
}

protocol SportsFactory {
    func makeShoe() -> Shoe
    func makeSoccerBall() -> Ball
    func makeBasketballBall() -> Ball
}

class NikeFactory: SportsFactory {
    func makeShoe() -> Shoe {
        return RunningShoe(price: 100.0, weight: 11.4, type: "Neutral")
    }
    
    func makeSoccerBall() -> Ball {
        return SoccerBall(price: 80)
    }
    
    func makeBasketballBall() -> Ball {
        return BasketballBall(price: 50)
    }
}

class AdidasFactory: SportsFactory {
    func makeShoe() -> Shoe {
        return RunningShoe(price: 200.0, weight: 11.0, type: "Neutral")
    }
    
    func makeSoccerBall() -> Ball {
        return SoccerBall(price: 100)
    }
    
    func makeBasketballBall() -> Ball {
        return BasketballBall(price: 60)
    }
}
/*:
 ### Usage
 */
let creators: [SportsFactory] = [NikeFactory(), AdidasFactory()]
for creator in creators {
    let soccerBall = creator.makeSoccerBall()
    let basketballBall = creator.makeBasketballBall()
    print(soccerBall.price)
    print(basketballBall.price)
}
/*:
 Singleton
 ----------

The singleton pattern ensures that only one object of a particular class is ever created.
All further references to objects of the singleton class refer to the same underlying instance.
There are very few applications, do not overuse this pattern!

### Example
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
 ### Usage
 */
Log.i(tag: .model, message: "info")
