# Swift Design Patterns

Design patterns are typical solutions to commonly occurring problems in software design.

Design patterns can speed up the development process by providing tested, proven
development paradigms.

## Table of Contents

* [Behavioral](#behavioral)
* [Creational](#creational)
* [Structural](#structural)

```swift
 Behavioral |
 [Creational](Creational) |
 [Structural](Structural)
```

## Behavioral

 >In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Behavioral_pattern)

```swift
import Swift
import Foundation
```

### Bridge

 The bridge pattern is used to separate the abstract elements of a class from the implementation details, providing the means to replace the implementation details without modifying the abstraction.

#### Bridge Implementation

```swift
protocol Switch {
    var appliance: Appliance! { get set }

    func turnOn()
    func turnOff()
}

class RemoteControl: Switch {
    var appliance: Appliance!

    func turnOn() {
        appliance.turnOn()
    }

    func turnOff() {
        appliance.turnOff()
    }
}

protocol Appliance {
    func turnOn()
    func turnOff()
}

class Lamp: Appliance {
    func turnOn() {
        print("Turning on Lamp")
    }

    func turnOff() {
        print("Turning off Lamp")
    }
}

class TV: Appliance {
    func turnOn() {
        print("Turning on TV")
    }

    func turnOff() {
        print("Turning off TV")
    }
}
```

#### Bridge Usage

```swift
var remoteControl: Switch = RemoteControl()

remoteControl.appliance = Lamp()
remoteControl.turnOn()

remoteControl.appliance = TV()
remoteControl.turnOn()
```

### Chain Of Responsibility

 The chain of responsibility pattern is used to process varied requests, each of which may be dealt with by a different handler.

#### Chain Of Responsibility Implementation

```swift
enum Denomination: Int {
    case ten = 10
    case twenty = 20
    case fifty = 50
    case oneHundred = 100
}

class MoneyPile {
    let denomination: Denomination
    var quantity: Int
    var nextPile: MoneyPile?

    init(denomination: Denomination, quantity: Int, nextPile: MoneyPile?) {
        self.denomination = denomination
        self.quantity = quantity
        self.nextPile = nextPile
    }

    func canWithdraw(amount: Int) -> Bool {
        var amount = amount

        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.denomination.rawValue) > 0
        }

        var quantity = self.quantity

        while canTakeSomeBill(want: amount) {
            if quantity == 0 {
                break
            }

            amount -= self.denomination.rawValue
            quantity -= 1
        }

        guard amount > 0 else {
            return true
        }

        if let next = self.nextPile {
            return next.canWithdraw(amount: amount)
        }

        return false
    }
}

class ATM {
    private var hundred: MoneyPile
    private var fifty: MoneyPile
    private var twenty: MoneyPile
    private var ten: MoneyPile

    private var startPile: MoneyPile {
        return self.hundred
    }

    init(hundred: MoneyPile, fifty: MoneyPile,
         twenty: MoneyPile, ten: MoneyPile) {
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }

    func canWithdraw(amount: Int) -> String {
        return "Can withdraw: \(self.startPile.canWithdraw(amount: amount))"
    }
}
```

#### Chain Of Responsibility Usage

```swift
// Create piles of money and link them together 10 < 20 < 50 < 100.**
let ten = MoneyPile(denomination: .ten, quantity: 6, nextPile: nil)
let twenty = MoneyPile(denomination: .twenty, quantity: 2, nextPile: ten)
let fifty = MoneyPile(denomination: .fifty, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(denomination: .oneHundred, quantity: 1, nextPile: fifty)

var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
print(atm.canWithdraw(amount: 310)) // Cannot because ATM has only 300
print(atm.canWithdraw(amount: 100)) // Can withdraw - 1x100
print(atm.canWithdraw(amount: 165)) // Cannot withdraw because ATM doesn't has bill with value of 5
print(atm.canWithdraw(amount: 30))  // Can withdraw - 1x20, 2x10
```

### Command

 The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.

#### Command Implementation

```swift
enum Operator {
    case plus
    case minus
    case asterisk
    case slash
}

protocol Command {
    func execute()
    func unExecute()
}

class CalculatorCommand: Command {
    let `operator`: Operator
    let operand: Int
    let calculator: Calculator

    init(calculator: Calculator, operator: Operator, operand: Int) {
        self.calculator = calculator
        self.operator = `operator`
        self.operand = operand
    }

    func execute() {
        calculator.operation(operator: `operator`, operand: operand)
    }

    func unExecute() {
        calculator.operation(operator: undo(`operator`), operand: operand)
    }

    private func undo(_ `operator`: Operator) -> Operator {
        switch `operator` {
        case .plus:
            return .minus
        case .minus:
            return .plus
        case .asterisk:
            return .slash
        case .slash:
            return .asterisk
        }
    }
}

class Calculator {
    private var current: Int = 0

    func operation(operator: Operator, operand: Int) {
        switch `operator` {
        case .plus:
            current += operand
        case .minus:
            current -= operand
        case .asterisk:
            current *= operand
        case .slash:
            current /= operand
        }
        print("Current value = \(current) (following \(`operator`) \(operand))")
    }
}

class Computer {
    private var calculator = Calculator()
    private var commands = [Command]()
    private var current = 0

    func redo(levels: Int) {
        print("\n---- Redo \(levels) levels")

        var i = 0
        while i < levels {
            if current < commands.count {
                let command = commands[current]
                current += 1
                command.execute()
            }
            i += 1
        }
    }

    func undo(levels: Int) {
        print("\n---- Undo \(levels) levels")

        var i = 0
        while i < levels {
            if current > 0 {
                current -= 1
                let command = commands[current]
                command.unExecute()
            }
            i += 1
        }
    }

    func compute(_ `operator`: Operator, _ operand: Int) {
        let command = CalculatorCommand(calculator: calculator, operator: `operator`, operand: operand)
        command.execute()
        commands.append(command)
        current += 1
    }
}
```

#### Command Usage

```swift
let computer = Computer()
computer.compute(.plus, 100)
computer.compute(.minus, 50)
computer.compute(.asterisk, 10)
computer.compute(.slash, 2)

computer.undo(levels: 4)

computer.redo(levels: 3)
```

### Immutable

 The immutable pattern is used to allow .

#### Immutable Implementation

```swift
class ImmutablePerson {
    private var name: String

    init(name: String) {
        self.name = name
    }

    func uppercased() -> String {
        return ImmutablePerson(name: self.name).name.uppercased()
    }
}
```

#### Immutable Usage

```swift
let person = ImmutablePerson(name: "Foo")
person.uppercased()
```

### Interpreter

The interpreter pattern is used to evaluate sentences in a language.

#### Interpreter Implementation

```swift
class Context {
    var input: String
    var output: Int = 0

    init(input: String) {
        self.input = input
    }
}

protocol Expression {
    func one() -> String
    func four() -> String
    func five() -> String
    func nine() -> String
    func multiplier() -> Int
}

extension Expression {
    func interpret(context: Context) {
        if context.input.count == 0 {
            return
        }

        if context.input.starts(with: nine()) {
            context.output += (9 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 2)
            context.input = String(context.input.suffix(from: index))
        } else if context.input.starts(with: four()) {
            context.output += (4 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 2)
            context.input = String(context.input.suffix(from: index))
        } else if context.input.starts(with: five()) {
            context.output += (5 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 1)
            context.input = String(context.input.suffix(from: index))
        }

        while context.input.starts(with: one()) {
            context.output += (1 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 1)
            context.input = String(context.input.suffix(from: index))
        }
    }
}

class ThousandExpression: Expression {
    func one() -> String {
        return "M"
    }

    func four() -> String {
        return " "
    }

    func five() -> String {
        return " "
    }

    func nine() -> String {
        return " "
    }

    func multiplier() -> Int {
        return 1000
    }
}

class HundredExpression: Expression {
    func one() -> String {
        return "C"
    }

    func four() -> String {
        return "CD"
    }

    func five() -> String {
        return "D"
    }

    func nine() -> String {
        return "CM"
    }

    func multiplier() -> Int {
        return 100
    }
}

class TenExpression: Expression {
    func one() -> String {
        return "X"
    }

    func four() -> String {
        return "XL"
    }

    func five() -> String {
        return "L"
    }

    func nine() -> String {
        return "XC"
    }

    func multiplier() -> Int {
        return 10
    }
}

class OneExpression: Expression {
    func one() -> String {
        return "I"
    }

    func four() -> String {
        return "IV"
    }

    func five() -> String {
        return "V"
    }

    func nine() -> String {
        return "IX"
    }

    func multiplier() -> Int {
        return 1
    }
}
```

#### Usage

```swift
let roman = "MCMXXVIII"
let context = Context(input: roman)

var expressions = Array<Expression>()
expressions.append(ThousandExpression())
expressions.append(HundredExpression())
expressions.append(TenExpression())
expressions.append(OneExpression())

for expression in expressions {
    expression.interpret(context: context)
}
print("\(roman) = \(context.output)")
```

### Iterator

 The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

#### Iterator Implementation

```swift
struct Song {
    let title: String
}

protocol MusicLibrary: Sequence {
    var songs: [Song] { get }
}

class MusicLibraryIterator: IteratorProtocol {
    private var current = 0
    private let songs: [Song]

    init(songs: [Song]) {
        self.songs = songs
    }

    func next() -> Song? {
        defer { current += 1 }
        return songs.count > current ? songs[current] : nil
    }
}

class PandoraIterator: MusicLibraryIterator {
}

class SpotifyIterator: MusicLibraryIterator {
}

class Pandora: MusicLibrary {
    var songs: [Song]

    init(songs: [Song]) {
        self.songs = songs
    }

    func makeIterator() -> MusicLibraryIterator {
        return PandoraIterator(songs: songs)
    }
}

class Spotify: MusicLibrary {
    var songs: [Song]

    init(songs: [Song]) {
        self.songs = songs
    }

    func makeIterator() -> MusicLibraryIterator {
        return SpotifyIterator(songs: songs)
    }
}
```

#### Iterator Usage

```swift
let spotify = Spotify(songs: [Song(title: "Foo"), Song(title: "Bar")] )

for song in spotify {
    print("I've read: \(song)")
}
```

### Mediator

 The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

#### Mediator Implementation

```swift
class Light {
    enum State {
        case on
        case off
    }

    private let color: String
    private var currentState: State = .off
    private let lightMediator: LightMediator

    init(color: String, lightMediator: LightMediator) {
        self.color = color
        self.lightMediator = lightMediator
        lightMediator.registerLight(self)
    }

    func turnOn() {
        currentState = .on
        print("\(color) is turned \(State.on) \n")
        lightMediator.notifyMediator(light: self)
    }

    func turnOff() {
        currentState = .off
        print("\(color) is turned \(State.off) \n")
    }
}

extension Light: Hashable {
    var hashValue: Int {
        return color.hashValue
    }
}

extension Light: Equatable {
    static func == (lhs: Light, rhs: Light) -> Bool {
        return lhs.color == rhs.color
    }
}

class LightMediator {
    private var lights = Set<Light>()

    func registerLight(_ light: Light) {
        lights.insert(light)
    }

    func unRegisterLight(_ light: Light) {
        lights.remove(light)
    }

    func turnOffAllOtherLights(light: Light) {
        for l in lights {
            if l != light {
                l.turnOff()
            }
        }
        print("------------------------------\n")
    }

    func notifyMediator(light: Light) {
        turnOffAllOtherLights(light: light)
    }
}
```

#### Mediator Usage

```swift
let lightMediator = LightMediator()
let red = Light(color: "Red", lightMediator: lightMediator)
let green = Light(color: "Green", lightMediator: lightMediator)
let yellow = Light(color: "Yellow", lightMediator: lightMediator)

red.turnOn()
green.turnOn()
yellow.turnOn()
```

### Memento

 The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.

#### Memento Implementation

```swift
class EditorMemento {
    let editorState: String

    init(state: String) {
        editorState = state
    }

    func getSavedState() -> String {
        return editorState
    }
}

class Editor {
    var contents = ""

    func save() -> EditorMemento {
        return EditorMemento(state: contents)
    }

    func restoreToState(memento: EditorMemento) {
        contents = memento.getSavedState()
    }
}
```

#### Memento Usage

```swift
let editor = Editor()
editor.contents = "Foo"
let memento = editor.save()

editor.contents = "Bar"
editor.restoreToState(memento: memento)
editor.contents
```

### Observer

 The observer pattern is used to allow an object to publish changes to its state.
 Other objects subscribe to be immediately notified of any changes.

#### Observer Implementation

```swift
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
```

#### Observer Usage

```swift
let foo = User()
let bar = User()

let shorts = Product()
shorts.attach(observer: foo)
shorts.attach(observer: bar)

shorts.inStock = true
```

### State

 The state pattern is used to alter the behaviour of an object as its internal state changes.
 The pattern allows the class for an object to apparently change at run-time.

#### State Implementation

```swift
class AppContext {
    private var state: State = UnauthorizedState()

    var isAuthorized: Bool {
        return state.isAuthorized(context: self)
    }

    var userId: String? {
        return state.userId(context: self)
    }

    func changeStateToAuthorized(userId: String) {
        state = AuthorizedState(userId: userId)
    }

    func changeStateToUnauthorized() {
        state = UnauthorizedState()
    }
}

protocol State {
    func isAuthorized(context: AppContext) -> Bool
    func userId(context: AppContext) -> String?
}

class UnauthorizedState: State {
    func isAuthorized(context: AppContext) -> Bool { return false }

    func userId(context: AppContext) -> String? { return nil }
}

class AuthorizedState: State {
    let userId: String

    init(userId: String) { self.userId = userId }

    func isAuthorized(context: AppContext) -> Bool { return true }

    func userId(context: AppContext) -> String? { return userId }
}
```

#### State Usage

```swift
let appContext = AppContext()
print(appContext.userId ?? "")
appContext.changeStateToAuthorized(userId: "admin")
print(appContext.userId ?? "")
appContext.changeStateToUnauthorized()
print(appContext.userId ?? "")
```

### Strategy

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

#### Strategy Implementation

```swift
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
```

#### Strategy Usage

```swift
let docFile = SaveFileDialog(strategy: DocFileStrategy())
docFile.save("file")

let textFile = SaveFileDialog(strategy: TextFileStrategy())
textFile.save("file")
```

### Template

 The Template Pattern is used when two or more implementations of an
 algorithm exist. The template is defined and then built upon with further
 variations. Use this method when most (or all) subclasses need to implement
 the same behavior. Traditionally, this would be accomplished with abstract
 classes and protected methods (as in Java). However in Swift, because
 abstract classes don't exist (yet - maybe someday),  we need to accomplish
 the behavior using interface delegation.

#### Template Implementation

```swift
protocol BoardGame {
    func play()
}

protocol BoardGamePhases {
    func initialize()
    func start()
}

class BoardGameController: BoardGame {
    private var delegate: BoardGamePhases

    init(delegate: BoardGamePhases) {
        self.delegate = delegate
    }

    private func openBox() {
        // common implementation
        print("BoardGameController openBox() executed")
    }

    final func play() {
        openBox()
        delegate.initialize()
        delegate.start()
    }
}

class Monoply: BoardGamePhases {
    func initialize() {
        print("Monoply initialize() executed")
    }

    func start() {
        print("Monoply start() executed")
    }
}

class Battleship: BoardGamePhases {
    func initialize() {
        print("Battleship initialize() executed")
    }

    func start() {
        print("Battleship start() executed")
    }
}
```

#### Template Usage

```swift
let monoply = BoardGameController(delegate: Monoply())
monoply.play()

let battleship = BoardGameController(delegate: Battleship())
battleship.play()
```

### Visitor

 The visitor pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold.

#### Visitor Implementation

```swift
protocol PlanetVisitor {
    func visit(planet: Earth)
    func visit(planet: Mars)
    func visit(planet: Jupiter)
}

protocol Planet {
    func accept(visitor: PlanetVisitor)
}

class Earth: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class Mars: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class Jupiter: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class NameVisitor: PlanetVisitor {
    var name = ""

    func visit(planet: Earth)  { name = "Earth" }
    func visit(planet: Mars) { name = "Mars" }
    func visit(planet: Jupiter)  { name = "Jupiter" }
}
```

#### Visitor Usage

```swift
let planets: [Planet] = [Earth(), Mars(), Jupiter()]

let names = planets.map { (planet: Planet) -> String in
    let visitor = NameVisitor()
    planet.accept(visitor: visitor)
    return visitor.name
}
```

## Creational

 > In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or in added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Creational_pattern)

```swift
import Swift
import Foundation
import UIKit
```

### Abstract Factory

 The abstract factory pattern is used to provide a client with a set of related or dependant objects.
 The "family" of objects created by the factory are determined at run-time.

#### Abstract Factory Implementation

```swift
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
```

#### Abstract Factory Usage

```swift
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
```

### Builder

 The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm.
 An external class controls the construction algorithm.

#### Builder Implementation

```swift
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
```

#### Chained builder Usage

```swift
let car = CarBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)
    .build()
print(car)
```

#### Using a director Usage

```swift
let motorcycleBuilder = MotorcycleBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)

let motorcycle = Shop().build(builder: motorcycleBuilder)
print(motorcycle)
```

### Factory Method

 The factory pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.

#### Factory Method Implementation

```swift
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
```

#### Factory Method Usage

```swift
let creators: [SportsFactory] = [NikeFactory(), AdidasFactory()]
for creator in creators {
    let soccerBall = creator.makeSoccerBall()
    let basketballBall = creator.makeBasketballBall()
    print(soccerBall.price)
    print(basketballBall.price)
}
```

### Object Pool

 The object pool pattern can offer a significant performance boost; it is most effective in situations where the cost of initializing a class instance is high, the rate of instantiation of a class is high, and the number of instantiations in use at any one time is low.

#### Object Pool Implementation

```swift
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
```

#### Object Pool Usage

```swift
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
```

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
