# Design Patterns in Swift

## What are design patterns?

Design patterns are the best, formalized practices a programmer can use to solve common problems when designing an application or system.

Design patterns can speed up the development process by providing tested, proven development paradigms.

Reusing design patterns help prevent subtle issues that cause major problems, and it also improves code readability for coders and architects who are familiar with the patterns.

## Table of Contents

- [Types of Design Patterns](#types-of-design-patterns)
  - [Behavioral](#behavioral)
  - [Creational](#creational)
  - [Structural](#structural)
- [License](#license)

## Types of Design Patterns

### Behavioral

 >In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Behavioral_pattern)

- [Bridge](behavioral/bridge.md)
- [Chain of Responsibility](behavioral/chain-of-responsibility.md)
- [Command](behavioral/command.md)
- [Immutable](behavioral/immutable.md)
- [Interpreter](behavioral/interpreter.md)
- [Iterator](behavioral/iterator.md)
- [Mediator](behavioral/mediator.md)
- [Memento](behavioral/memento.md)
- [Observer](behavioral/observer.md)
- [State](behavioral/state.md)
- [Strategy](behavioral/strategy.md)
- [Template](behavioral/template.md)
- [Visitor](behavioral/visitor.md)

## Creational

 > In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or in added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Creational_pattern)

- [Abstract Factory](creational/abstract-factory.md)
- [Builder](creational/builder.md)
- [Factory Method](creational/factory-method.md)
- [Object Pool](creational/object-pool.md)

### Prototype

 The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone.
 This practise is particularly useful when the construction of a new object is inefficient.

#### Prototype Implementation

```swift
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
````

#### Prototype Usage

```swift
let base = Paragraph()

let title = base.clone()
title.font = UIFont.systemFont(ofSize: 18)
title.text = "This is the title"

let first = base.clone()
first.text = "This is the first paragraph"

let second = base.clone()
second.text = "This is the second paragraph"
```

### Simple Factory

 The simple factory pattern allows interfaces for creating objects without exposing the object creation logic to the client.

#### Simple Factory Implementation

```swift
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
```

#### Simple Factory Usage

```swift
let superMario = SimpleFactory.createVideoGame(type: .adventure)
superMario.play()

let streetFighter = SimpleFactory.createVideoGame(type: .combat)
streetFighter.play()
```

### Singleton

The singleton pattern ensures that only one object of a particular class is ever created.
All further references to objects of the singleton class refer to the same underlying instance.
There are very few applications, do not overuse this pattern!

#### Singleton Implementation

```swift
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
```

#### Singleton Usage

```swift
Log.i(tag: .model, message: "info")
```

## Structural

 >In software engineering, structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Structural_pattern)

```swift
import Swift
import Foundation
import UIKit
```

### Adapter

 The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.

#### Adapter Implementation

```swift
class XMLParser {
    private let response: XMLResponse

    init(response: XMLResponse) {
        self.response = response
    }

    func parse() -> JSONResponse {
        return JSONResponse()
    }
}

class JSONResponse {
    let value = "[{}]"
}

class XMLResponse {
    let value = "<?xml version=\"1.0\" ?><note></note>"
}

protocol HTTPRequestTarget {
    func request() -> JSONResponse
}

class HTTPClient: HTTPRequestTarget {
    private let adaptee: LegacyHTTPClient

    init(_ adaptee: LegacyHTTPClient) {
        self.adaptee = adaptee
    }

    func request() -> JSONResponse {
        let xmlResponse = adaptee.request()
        let jsonResponse = XMLParser(response: xmlResponse)
        return jsonResponse.parse()
    }
}

class LegacyHTTPClient {
    func request() -> XMLResponse {
        return XMLResponse()
    }
}
```

#### Adapter Usage

```swift
let adaptee = LegacyHTTPClient()
let adapter = HTTPClient(adaptee)

adapter.request()
```

### Private Class Data

The private class data design pattern seeks to reduce exposure of attributes by limiting their visibility.

#### Private Class Data Implementation

```swift
private class CircleData {
    var radius: Double
    var color: UIColor
    var origin: CGPoint

    init(radius: Double, color: UIColor, origin: CGPoint) {
        self.radius = radius
        self.color = color
        self.origin = origin
    }
}

class Circle {
    private let circleData: CircleData

    init(radius: Double, color: UIColor, origin: CGPoint) {
        self.circleData = CircleData(radius: radius, color: color, origin: origin)
    }

    var circumference: Double {
        return circleData.radius * Double.pi
    }

    var diameter: Double {
        return circleData.radius * 2
    }

    func draw(graphics: Data) {
    }
}
```

#### Private Class Data Usage

```swift
let circle = Circle(radius: 3.0, color: .red, origin: .zero)
print(circle.circumference)
```

### Composite

 The composite pattern is used to create hierarchical, recursive tree structures of related objects where any element of the structure may be accessed and utilised in a standard manner.

#### Composite Implementation

```swift
enum ValidatorResult {
    case valid
    case invalid(error: Error)
}

protocol Validator {
    func validate(_ value: String) -> ValidatorResult
}

enum EmailValidatorError: Error {
    case empty
    case invalidFormat
}

enum PasswordValidatorError: Error {
    case empty
    case tooShort
    case noUppercaseLetter
    case noLowercaseLetter
    case noNumber
}

struct EmptyStringValidator: Validator {
    // This error is passed via the initializer to allow this validator to be reused
    private let invalidError: Error

    init(invalidError: Error) {
        self.invalidError = invalidError
    }

    func validate(_ value: String) -> ValidatorResult {
        if value.isEmpty {
            return .invalid(error: invalidError)
        } else {
            return .valid
        }
    }
}

struct EmailFormatValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        let magicEmailRegexStolenFromTheInternet = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", magicEmailRegexStolenFromTheInternet)

        if emailTest.evaluate(with: value) {
            return .valid
        } else {
            return .invalid(error: EmailValidatorError.invalidFormat)
        }
    }
}

struct PasswordLengthValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        if value.count >= 8 {
            return .valid
        } else {
            return .invalid(error: PasswordValidatorError.tooShort)
        }
    }
}

struct UppercaseLetterValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        let uppercaseLetterRegex = ".*[A-Z]+.*"

        let uppercaseLetterTest = NSPredicate(format:"SELF MATCHES %@", uppercaseLetterRegex)

        if uppercaseLetterTest.evaluate(with: value) {
            return .valid
        } else {
            return .invalid(error: PasswordValidatorError.noUppercaseLetter)
        }
    }
}

struct CompositeValidator: Validator {
    private let validators: [Validator]

    init(validators: Validator...) {
        self.validators = validators
    }

    func validate(_ value: String) -> ValidatorResult {
        for validator in validators {
            switch validator.validate(value) {
            case .valid:
                break
            case .invalid(let error):
                return .invalid(error: error)
            }
        }
        return .valid
    }
}

struct ValidatorConfigurator {
    static let shared = ValidatorConfigurator()

    func emailValidator() -> Validator {
        return CompositeValidator(validators: emptyEmailStringValidator(),
                                  EmailFormatValidator())
    }

    func passwordValidator() -> Validator {
        return CompositeValidator(validators: emptyPasswordStringValidator(),
                                  passwordStrengthValidator())
    }

    private func emptyEmailStringValidator() -> Validator {
        return EmptyStringValidator(invalidError: EmailValidatorError.empty)
    }

    private func emptyPasswordStringValidator() -> Validator {
        return EmptyStringValidator(invalidError: PasswordValidatorError.empty)
    }

    private func passwordStrengthValidator() -> Validator {
        return CompositeValidator(validators: PasswordLengthValidator(),
                                  UppercaseLetterValidator())
    }
}
```

#### Composite Usage

```swift
let validatorConfigurator = ValidatorConfigurator.shared
let emailValidator = validatorConfigurator.emailValidator()
let passwordValidator = validatorConfigurator.passwordValidator()

print(emailValidator.validate(""))
print(emailValidator.validate("invalidEmail@"))
print(emailValidator.validate("validEmail@validDomain.com"))

print(passwordValidator.validate(""))
print(passwordValidator.validate("psS$"))
print(passwordValidator.validate("passw0rd"))
print(passwordValidator.validate("paSSw0rd"))
```

#### Decorator

 The decorator pattern is used to extend or alter the functionality of objects at run- time by wrapping them in an object of a decorator class.
 This provides a flexible alternative to using inheritance to modify behaviour.

#### Decorator Implementation

```swift
protocol Element {
    func imagePath() -> String
}

class Shape: Element {
    func imagePath() -> String {
        return "shape.png"
    }
}

class Object: Element {
    func imagePath() -> String {
        return "object.png"
    }
}

class ElementDecorator: Element {
    private let decoratedElement: Element

    required init(decoratedElement: Element) {
        self.decoratedElement = decoratedElement
    }

    func imagePath() -> String {
        return decoratedElement.imagePath()
    }
}

final class ColorDecorator: ElementDecorator {
    required init(decoratedElement: Element) {
        super.init(decoratedElement: decoratedElement)
    }

    override func imagePath() -> String {
        return "color-" + super.imagePath()
    }
}

final class SizeDecorator: ElementDecorator {
    required init(decoratedElement: Element) {
        super.init(decoratedElement: decoratedElement)
    }

    override func imagePath() -> String {
        return "size-" + super.imagePath()
    }
}
```

#### Decorator Usage

```swift
var element: Element = Shape()
print("Path = \(element.imagePath())")
element = ColorDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")
element = SizeDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")
```

### Façade

 The facade pattern is used to define a simplified interface to a more complex subsystem.

#### Façade Implementation

```swift
protocol FlightBooking {
    func book()
}

class FlightBookingSystem: FlightBooking {
    func book() {
        print("Flight booked successfully")
    }
}

protocol HotelBooking {
    func book()
}

class HotelBookingSystem: HotelBooking {
    func book() {
        print("Hotel booked successfully")
    }
}

protocol TrasferBooking {
    func book()
}

class TrasferBookingSystem: TrasferBooking {
    func book() {
        print("Transfer booked successfully")
    }
}

protocol TravelPackage {
    func book()
}

class TravelPackageFacade: TravelPackage {
    func book() {
        let trasferBooking = TrasferBookingSystem()
        trasferBooking.book()

        let hotelBooking = HotelBookingSystem()
        hotelBooking.book()

        let flightBooking = FlightBookingSystem()
        flightBooking.book()

        print("Travel package booked successfully")
    }
}
```

#### Façade Usage

```swift
let travelPackage = TravelPackageFacade()
travelPackage.book()
```

### Flyweight

The flyweight pattern is used to minimize memory usage or computational expenses by sharing as much as possible with other similar objects.

#### Flyweight Implementation

```swift
protocol Soldier {
    func render(from location: CGPoint, to newLocation: CGPoint)
}

class Infantry: Soldier {
    private let modelData: Data

    init(modelData: Data) {
        self.modelData = modelData
    }

    func render(from location: CGPoint, to newLocation: CGPoint) {
        // Remove rendering from original location
        // Graphically render at new location
    }
}

class Aviation: Soldier {
    private let modelData: Data

    init(modelData: Data) {
        self.modelData = modelData
    }

    func render(from location: CGPoint, to newLocation: CGPoint) {
        // Remove rendering from original location
        // Graphically render at new location
    }
}

class Radar {
    var currentLocation: CGPoint
    let soldier: Soldier

    init(currentLocation: CGPoint, soldier: Soldier) {
        self.currentLocation = currentLocation
        self.soldier = soldier
    }

    func moveSoldier(to nextLocation: CGPoint) {
        soldier.render(from: currentLocation, to: nextLocation)
        currentLocation = nextLocation
    }
}

class SoldierFactory {
    enum SoldierType {
        case infantry
        case aviation
    }

    private var availableSoldiers =  [SoldierType: Soldier]()
    static let shared = SoldierFactory()

    private init() { }

    private func createSoldier(of type: SoldierType) -> Soldier {
        switch type {
        case .infantry:
            let infantry = Infantry(modelData: Data())
            availableSoldiers[type] = infantry
            return infantry
        case .aviation:
            let infantry = Infantry(modelData: Data())
            availableSoldiers[type] = infantry
            return infantry
        }
    }

    func getSoldier(type: SoldierType) -> Soldier {
        if let soldier = availableSoldiers[type] {
            return soldier
        } else {
            let soldier = createSoldier(of: type)
            return soldier
        }
    }
}
```

#### Flyweight Usage

```swift
let soldierFactory = SoldierFactory.shared
let infantry = soldierFactory.getSoldier(type: .infantry)
let infantryRadar = Radar(currentLocation: .zero, soldier: infantry)
infantryRadar.moveSoldier(to: CGPoint(x: 1, y: 5))

var aviation = soldierFactory.getSoldier(type: .aviation)
let aviationRadar = Radar(currentLocation: CGPoint(x: 5, y: 10), soldier: aviation)
aviation = soldierFactory.getSoldier(type: .aviation) // Same soldier
aviationRadar.moveSoldier(to: CGPoint(x: 1, y: 5))
```

### Protection Proxy

 The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object.
 Protection proxy is restricting access.

#### Protection Proxy Implementation

```swift
struct Resource {
    let id: String
}

protocol Authenticable {
    func getResourceById(_ id: String) -> Resource?
}

class ResourceManager: Authenticable {
    let resources = [Resource(id: "1"), Resource(id: "2"), Resource(id: "3")]
    func getResourceById(_ id: String) -> Resource? {
        return self.resources.first(where: { $0.id == id })
    }
}

class VaultManager: Authenticable {
    private var resourceManager: ResourceManager!

    func authenticate(password: String) -> Bool {
        guard password == "pass" else {
            return false
        }

        resourceManager = ResourceManager()

        return true
    }

    func getResourceById(_ id: String) -> Resource? {
        guard resourceManager != nil else {
            return nil
        }

        return resourceManager.getResourceById(id)
    }
}
```

#### Protection Proxy Usage

```swift
let vaultManager = VaultManager()
_ = vaultManager.getResourceById("123")

_ = vaultManager.authenticate(password: "pass")
_ = vaultManager.getResourceById("1")
```

### Virtual Proxy

 The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object.
 Virtual proxy is used for loading object on demand.

#### Virtual Proxy Implementation

```swift
protocol Imageable {
    func render() -> UIImage
}

public class RealImage: Imageable {
    private var image: UIImage!

    init(url: URL) {
        loadImageURL(url)
    }

    private func loadImageURL(_ url: URL) {
        image = UIImage()
    }

    func render() -> UIImage {
        return image
    }
}

class ProxyImage: Imageable {
    private let url: URL
    private lazy var realImage = RealImage(url: self.url)

    init(url: URL) {
        self.url = url
    }

    func render() -> UIImage {
        return realImage.render()
    }
}
```

#### Virtual Proxy Usage

```swift
let proxyImage = ProxyImage(url: URL(string: "")!)
_ = proxyImage.render()
```

## License

Licensed under MIT License. See [LICENSE](LICENSE) for further details.
