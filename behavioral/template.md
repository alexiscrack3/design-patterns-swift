# Template

The template pattern is used when two or more implementations of an algorithm exist. The template is defined and then built upon with further variations. Use this method when most (or all) subclasses need to implement the same behavior. Traditionally, this would be accomplished with abstract classes and protected methods (as in Java). However in Swift, because abstract classes don't exist (yet - maybe someday),  we need to accomplish the behavior using interface delegation.

## Example

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

### Usage

```swift
let monoply = BoardGameController(delegate: Monoply())
monoply.play()

let battleship = BoardGameController(delegate: Battleship())
battleship.play()
```

### Output

```text
BoardGameController openBox() executed
Monoply initialize() executed
Monoply start() executed
BoardGameController openBox() executed
Battleship initialize() executed
Battleship start() executed
```
