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
- [Prototype](creational/prototype.md)
- [Simple Factory](creational/simple-factory.md)
- [Singleton](creational/singleton.md)

## Structural

 >In software engineering, structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Structural_pattern)

- [Adapter](structural/adapter.md)
- [Private Class Data](structural/private-class-data.md)
- [Composite](structural/composite.md)
- [Decorator](structural/decorator.md)
- [Façade](structural/facade.md)
- [Flyweight](structural/flyweight.md)

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
