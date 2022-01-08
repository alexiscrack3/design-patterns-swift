# Builder

The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm. An external class controls the construction algorithm.

## Example

```swift
class Shop {
    func build(builder: VehicleBuilder) -> Vehicle {
        return builder.build()
    }
}

protocol VehicleBuilder {
    var frame: String? { get }
    var engine: String? { get }
    var wheels: Int? { get }
    var doors: Int? { get }

    func setFrame(_ frame: String) -> VehicleBuilder
    func setEngine(_ engine: String) -> VehicleBuilder
    func setWheels(_ frame: Int) -> VehicleBuilder
    func setDoors(_ frame: Int) -> VehicleBuilder
    func build() -> Vehicle
}

class CarBuilder: VehicleBuilder {
    var frame: String?
    var engine: String?
    var wheels: Int?
    var doors: Int?

    func setFrame(_ frame: String) -> VehicleBuilder {
        self.frame = frame
        return self
    }

    func setEngine(_ engine: String) -> VehicleBuilder {
        self.engine = engine
        return self
    }

    func setWheels(_ wheels: Int) -> VehicleBuilder {
        self.wheels = wheels
        return self
    }

    func setDoors(_ doors: Int) -> VehicleBuilder {
        self.doors = doors
        return self
    }

    func build() -> Vehicle {
        return Vehicle(frame: self.frame ?? "", engine: self.engine ?? "", wheels: self.wheels ?? 0, doors: self.doors ?? 0)
    }
}

class MotorcycleBuilder: VehicleBuilder {
    var frame: String?
    var engine: String?
    var wheels: Int?
    var doors: Int?

    func setFrame(_ frame: String) -> VehicleBuilder {
        self.frame = "Motorcycle - " + frame
        return self
    }

    func setEngine(_ engine: String) -> VehicleBuilder {
        self.engine = "Motorcycle - " + engine
        return self
    }

    func setWheels(_ wheels: Int) -> VehicleBuilder {
        self.wheels = wheels
        return self
    }

    func setDoors(_ doors: Int) -> VehicleBuilder {
        self.doors = doors
        return self
    }

    func build() -> Vehicle {
        return Vehicle(frame: self.frame ?? "", engine: self.engine ?? "", wheels: self.wheels ?? 0, doors: self.doors ?? 0)
    }
}

struct Vehicle {
    var frame: String
    var engine: String
    var wheels: Int
    var doors: Int
}
```

### Usage

```swift
let car = CarBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)
    .build()
print(car)
```

### Output

```text
Vehicle(frame: "Frame", engine: "Engine", wheels: 4, doors: 4)
```

## Director Usage

```swift
let motorcycleBuilder = MotorcycleBuilder()
    .setFrame("Frame")
    .setEngine("Engine")
    .setWheels(4)
    .setDoors(4)

let motorcycle = Shop().build(builder: motorcycleBuilder)
print(motorcycle)
```

### Output Director

```text
Vehicle(frame: "Motorcycle - Frame", engine: "Motorcycle - Engine", wheels: 4, doors: 4)
```
