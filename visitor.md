# Visitor

The visitor pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold.

## Example

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

## Usage

```swift
let planets: [Planet] = [Earth(), Mars(), Jupiter()]

let names = planets.map { (planet: Planet) -> String in
    let visitor = NameVisitor()
    planet.accept(visitor: visitor)
    return visitor.name
}
```
