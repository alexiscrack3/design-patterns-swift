# Abstract Factory

The abstract factory pattern is used to provide a client with a set of related or dependant objects. The "family" of objects created by the factory are determined at run-time.

## Example

```swift
protocol Sedan {
    func drive()
}

class CompactSedan: Sedan {
    func drive() {
        print("drive a compact sedan")
    }
}

class FullSizeSedan: Sedan {
    func drive() {
        print("drive a full-size sedan")
    }
}

protocol Hatchback {
    func drive()
}

class CompactHatchback: Hatchback {
    func drive() {
        print("drive a compact SUV")
    }
}

class FullSizeHatchback: Hatchback {
    func drive() {
        print("drive a full-size SUV")
    }
}

protocol Factory {
    func produceSedan() -> Sedan
    func produceHatchback() -> Hatchback
}

class CompactCarsFactory: Factory {
    func produceSedan() -> Sedan {
        return CompactSedan()
    }

    func produceHatchback() -> Hatchback {
        return CompactHatchback()
    }
}

class FullSizeCarsFactory: Factory {
    func produceSedan() -> Sedan {
        return FullSizeSedan()
    }

    func produceHatchback() -> Hatchback {
        return FullSizeHatchback()
    }
}
```

### Usage

```swift
let compactCarsFactory = CompactCarsFactory()
let compactSedan = compactCarsFactory.produceSedan()
let compactHatchback = compactCarsFactory.produceHatchback()
compactSedan.drive()
compactHatchback.drive()

let fullSizeCarsFactory = FullSizeCarsFactory()
let fullsizeSedan = fullSizeCarsFactory.produceSedan()
let fullsizeHatchback = fullSizeCarsFactory.produceHatchback()
fullsizeSedan.drive()
fullsizeHatchback.drive()
```
