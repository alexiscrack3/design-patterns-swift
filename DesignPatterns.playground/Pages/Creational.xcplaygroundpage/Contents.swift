//: [Behavioral](Behavioral) |
//: Creational |
//: [Structural](Structural)
/*:
# Creational

 > In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or in added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Creational_pattern)
 */
import Swift
import Foundation
import UIKit
/*:
## Abstract Factory

The abstract factory pattern is used to provide a client with a set of related or dependant objects. The "family" of objects created by the factory are determined at run-time.

### Implementation
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
    func produceSedan() -> Sedan {
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
## Builder

The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm. An external class controls the construction algorithm.

### Implementation
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
### Usage Chained builder
 */
let car = CarBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)
    .build()
print(car)
/*:
### Usage Using a director
 */
let motorcycleBuilder = MotorcycleBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)

let motorcycle = Shop().build(builder: motorcycleBuilder)
print(motorcycle)
/*:
## Factory Method

The factory method pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.

### Implementation
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
## Object Pool

The object pool pattern can offer a significant performance boost; it is most effective in situations where the cost of initializing a class instance is high, the rate of instantiation of a class is high, and the number of instantiations in use at any one time is low.

### Implementation
 */
struct MagicObject {
    let name: String
    let serialNumber: Int
    var occupier: [String] = []
    var borrowedCount: Int = 0
}

class Pool<T> {
    var magicObjects = [T]()
    private let arrayQ = DispatchQueue(label: "array")
    private let semaphore: DispatchSemaphore

    init(items: [T]) {
        magicObjects.reserveCapacity(magicObjects.count)
        for item in items {
            magicObjects.append(item)
        }
        // create a counter semaphore for the available items in the pool
        semaphore = DispatchSemaphore(value: items.count)
    }

    func getFromPool() -> T? {
        var result: T?
        // the semaphore count is decreased each time when the wait is called. If the count is 0, the function will block
        if semaphore.wait(timeout: .distantFuture) == DispatchTimeoutResult.success {
            if magicObjects.count > 0 {
                arrayQ.sync {
                    result = self.magicObjects.remove(at: 0)
                }
            }
        }
        return result
    }

    func returnToPool(item: T) {
        arrayQ.sync {
            self.magicObjects.append(item)
            // increase the counter by 1
            self.semaphore.signal()
            //            DispatchSemaphore.signal(self.semaphore)()
        }
    }
}

extension Int {
    func times(action: (Int)->()) {
        for i in 0..<self {
            action(i)
        }
    }
}
class MagicHouse {
    private let pool: Pool<MagicObject>
    static var sharedInstance = MagicHouse()
    static var magicDebtInfo: [(String, Int, String)] = []

    private init() {
        var magicObjects:[MagicObject] = []
        2.times {
            magicObjects.append(MagicObject(name: "Red Diamond", serialNumber: $0, occupier: [], borrowedCount: 0))
        }
        3.times {
            magicObjects.append(MagicObject(name: "Blue Heart", serialNumber: $0, occupier: [], borrowedCount: 0))
        }
        self.pool = Pool(items: magicObjects)
    }

    static func lendMagicObject(occupier: String) -> MagicObject? {
        var magicObject = sharedInstance.pool.getFromPool()
        if magicObject != nil {
            magicObject!.occupier.append(occupier)
            magicObject!.borrowedCount += 1
            magicDebtInfo.append((magicObject!.name, magicObject!.serialNumber, occupier))
            print("\(occupier) is borrowing \(magicObject!.name) #\(magicObject!.serialNumber)")
        }
        return magicObject
    }

    static func receiveMagicObject(obj: MagicObject) {
        magicDebtInfo = magicDebtInfo.filter {
            $0.0 != obj.name && $0.1 != obj.serialNumber
        }
        sharedInstance.pool.returnToPool(item: obj)
        print("\(obj.occupier.last!) returning \(obj.name) #\(obj.serialNumber)")
    }

    static func printReport() {
        print("\nShow Report: Magic House currently has \(sharedInstance.pool.magicObjects.count) magic object(s) in stock")
        sharedInstance.pool.magicObjects.forEach {
            print("\($0.name) #\($0.serialNumber) \nBorrowed \($0.borrowedCount) time(s) by \($0.occupier)")
        }

        if magicDebtInfo.count > 0 {
            print("\nMagic Objects currently lent out:")
            magicDebtInfo.forEach {
                print("\($0.0) #\($0.1) by \($0.2)")
            }
        }
    }
}
/*:
### Usage
 */
let queue = DispatchQueue(label: "workQ", attributes: .concurrent)
let group = DispatchGroup()

print("\n------Starting test...")

for i in 1...7 {
    queue.async(group: group, execute: DispatchWorkItem(block: {
        if let obj = MagicHouse.lendMagicObject(occupier: "person #\(i)") {
            Thread.sleep(forTimeInterval: Double(arc4random_uniform(10)))
            MagicHouse.receiveMagicObject(obj: obj)
        }
    }))
}

_ = group.wait(timeout: .distantFuture)
_ = MagicHouse.lendMagicObject(occupier: "William")
_ = MagicHouse.lendMagicObject(occupier: "Tato")
MagicHouse.printReport()
/*:
## Prototype

The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone. This practise is particularly useful when the construction of a new object is inefficient.

### Implementation
 */
protocol TextScheme {
    var font: UIFont { get set }
    var color: UIColor { get set }
    var text: String { get set}
    func clone() -> Paragraph
}

class Paragraph: TextScheme {
    var font: UIFont
    var color: UIColor
    var text: String

    init(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = .darkText, text: String = "") {
        self.font = font
        self.color = color
        self.text = text
    }

    func clone() -> Paragraph {
        return Paragraph(font: self.font, color: self.color, text: self.text)
    }
}
/*:
### Usage
 */
let base = Paragraph()

let title = base.clone()
title.font = UIFont.systemFont(ofSize: 18)
title.text = "This is the title"

let first = base.clone()
first.text = "This is the first paragraph"

let second = base.clone()
second.text = "This is the second paragraph"
print(first)
print(second)
/*:
## Simple Factory

The simple factory pattern allows interfaces for creating objects without exposing the object creation logic to the client.

### Implementation
 */
enum VideoGameType {
    case adventure, combat
}

protocol VideoGame {
    func play()
}

class SuperMario : VideoGame {
    func play() {
    }
}

class StreetFighter: VideoGame {
    func play() {
    }
}

class SimpleFactory {
    static func createVideoGame(type: VideoGameType) -> VideoGame {
        switch type {
        case .adventure:
            return SuperMario()
        case .combat:
            return StreetFighter()
        }
    }
}
/*:
### Usage
 */
let superMario = SimpleFactory.createVideoGame(type: .adventure)
superMario.play()

let streetFighter = SimpleFactory.createVideoGame(type: .combat)
streetFighter.play()
/*:
## Singleton

The singleton pattern ensures that only one object of a particular class is ever created. All further references to objects of the singleton class refer to the same underlying instance. There are very few applications, do not overuse this pattern!

### Implementation
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
