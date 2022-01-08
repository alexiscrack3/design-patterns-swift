# Observer

The observer pattern is used to allow an object to publish changes to its state.
Other objects subscribe to be immediately notified of any changes.

## Example

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

## Usage

```swift
let foo = User()
let bar = User()

let shorts = Product()
shorts.attach(observer: foo)
shorts.attach(observer: bar)

shorts.inStock = true
```
