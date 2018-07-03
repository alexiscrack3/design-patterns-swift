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
 Immutable
 ----------
 
 The immutable pattern is used to allow .
 
 ### Example
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
 Iterator
 ---------
 
 The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.
 
 ### Example:
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
 Observer
 ---------
 
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
 ---------
    
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
/*:
 Template
 ---------
 
 The Template Pattern is used when two or more implementations of an
 algorithm exist. The template is defined and then built upon with further
 variations. Use this method when most (or all) subclasses need to implement
 the same behavior. Traditionally, this would be accomplished with abstract
 classes and protected methods (as in Java). However in Swift, because
 abstract classes don't exist (yet - maybe someday),  we need to accomplish
 the behavior using interface delegation.
 
 ### Example
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
monoply.play();

let battleship = BoardGameController(delegate: Battleship())
battleship.play();
