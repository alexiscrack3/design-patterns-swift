# Simple Factory

The simple factory pattern allows interfaces for creating objects without exposing the object creation logic to the client.

## Example

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

### Usage

```swift
let superMario = SimpleFactory.createVideoGame(type: .adventure)
superMario.play()

let streetFighter = SimpleFactory.createVideoGame(type: .combat)
streetFighter.play()
```
