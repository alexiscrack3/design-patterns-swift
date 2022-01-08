//: Behavioral |
//: [Creational](Creational) |
//: [Structural](Structural)
/*:
# Behavioral

 >In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Behavioral_pattern)
 */
import Swift
import Foundation
/*:
## Bridge

 The bridge pattern is used to separate the abstract elements of a class from the implementation details, providing the means to replace the implementation details without modifying the abstraction.

### Implementation

 */
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
        print("Turning the lamp on")
    }

    func turnOff() {
        print("Turning the lamp off")
    }
}

class TV: Appliance {
    func turnOn() {
        print("Turning the TV On")
    }

    func turnOff() {
        print("Turning the TV On")
    }
}
/*:
### Usage
 */
var remoteControl: Switch = RemoteControl()

remoteControl.appliance = Lamp()
remoteControl.turnOn()

remoteControl.appliance = TV()
remoteControl.turnOn()
/*:
## Chain Of Responsibility

 The chain of responsibility pattern is used to process varied requests, each of which may be dealt with by a different handler.

### Implementation
 */
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
/*:
### Usage
 */
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
/*:
## Command

 The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.

### Implementation
 */
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
/*:
### Usage
 */
let computer = Computer()
computer.compute(.plus, 100)
computer.compute(.minus, 50)
computer.compute(.asterisk, 10)
computer.compute(.slash, 2)

computer.undo(levels: 4)

computer.redo(levels: 3)
/*:
## Immutable

 The immutable pattern is used to allow .

### Implementation
 */
class ImmutablePerson {
    private var name: String

    init(name: String) {
        self.name = name
    }

    func uppercased() -> String {
        return ImmutablePerson(name: self.name).name.uppercased()
    }
}
/*:
### Usage
 */
let person = ImmutablePerson(name: "Foo")
person.uppercased()
/*:
## Interpreter

The interpreter pattern is used to evaluate sentences in a language.

### Implementation
*/
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
/*:
### Usage
*/
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
/*:
## Iterator

 The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

### Implementation
 */
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
/*:
### Usage
 */
let spotify = Spotify(songs: [Song(title: "Foo"), Song(title: "Bar")] )

for song in spotify {
    print("I've read: \(song)")
}
/*:
## Mediator

 The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

### Implementation
 */
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
/*:
### Usage
 */
let lightMediator = LightMediator()
let red = Light(color: "Red", lightMediator: lightMediator)
let green = Light(color: "Green", lightMediator: lightMediator)
let yellow = Light(color: "Yellow", lightMediator: lightMediator)

red.turnOn()
green.turnOn()
yellow.turnOn()
/*:
## Memento

 The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.

### Implementation
 */

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
/*:
### Usage
 */
let editor = Editor()
editor.contents = "Foo"
let memento = editor.save()

editor.contents = "Bar"
editor.restoreToState(memento: memento)
editor.contents
/*:
## Observer

 The observer pattern is used to allow an object to publish changes to its state.
 Other objects subscribe to be immediately notified of any changes.

### Observer Implementation
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
## State

 The state pattern is used to alter the behaviour of an object as its internal state changes.
 The pattern allows the class for an object to apparently change at run-time.

### Implementation
 */
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
/*:
### Usage
 */
let appContext = AppContext()
print(appContext.userId ?? "")
appContext.changeStateToAuthorized(userId: "admin")
print(appContext.userId ?? "")
appContext.changeStateToUnauthorized()
print(appContext.userId ?? "")
/*:
## Strategy

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

### Implementation
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
/*:
## Template

 The Template Pattern is used when two or more implementations of an
 algorithm exist. The template is defined and then built upon with further
 variations. Use this method when most (or all) subclasses need to implement
 the same behavior. Traditionally, this would be accomplished with abstract
 classes and protected methods (as in Java). However in Swift, because
 abstract classes don't exist (yet - maybe someday),  we need to accomplish
 the behavior using interface delegation.

### Implementation
 */
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
/*:
### Usage
 */
let monoply = BoardGameController(delegate: Monoply())
monoply.play()

let battleship = BoardGameController(delegate: Battleship())
battleship.play()
/*:
## Visitor

 The visitor pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold.

### Implementation
 */
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
/*:
### Usage
 */
let planets: [Planet] = [Earth(), Mars(), Jupiter()]

let names = planets.map { (planet: Planet) -> String in
    let visitor = NameVisitor()
    planet.accept(visitor: visitor)
    return visitor.name
}
