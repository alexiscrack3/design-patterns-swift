# Bridge

The bridge pattern is used to separate the abstract elements of a class from the implementation details, providing the means to replace the implementation details without modifying the abstraction.

## Example

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
        print("Turning the lamp on")
    }

    func turnOff() {
        print("Turning the lamp off")
    }
}

class TV: Appliance {
    func turnOn() {
        print("Turning the TV on")
    }

    func turnOff() {
        print("Turning the TV off")
    }
}
```

### Usage

```swift
var remoteControl: Switch = RemoteControl()

remoteControl.appliance = Lamp()
remoteControl.turnOn()

remoteControl.appliance = TV()
remoteControl.turnOn()
```

### Output

```text
Turning the lamp on
Turning the TV on
```
