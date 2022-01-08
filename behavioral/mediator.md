# Mediator

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

## Example

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

### Usage

```swift
let lightMediator = LightMediator()
let red = Light(color: "Red", lightMediator: lightMediator)
let green = Light(color: "Green", lightMediator: lightMediator)
let yellow = Light(color: "Yellow", lightMediator: lightMediator)

red.turnOn()
green.turnOn()
yellow.turnOn()
```

### Output

```text
Red is turned on

Green is turned off

Yellow is turned off

------------------------------

Green is turned on

Yellow is turned off

Red is turned off

------------------------------

Yellow is turned on

Green is turned off

Red is turned off

------------------------------
```
