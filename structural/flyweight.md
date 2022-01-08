# Flyweight

The flyweight pattern is used to minimize memory usage or computational expenses by sharing as much as possible with other similar objects.

## Example

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

### Usage

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
