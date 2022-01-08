# Private Class Data

The private class data design pattern seeks to reduce exposure of attributes by limiting their visibility.

## Example

```swift
private class CircleData {
    var radius: Double
    var color: UIColor
    var origin: CGPoint

    init(radius: Double, color: UIColor, origin: CGPoint) {
        self.radius = radius
        self.color = color
        self.origin = origin
    }
}

class Circle {
    private let circleData: CircleData

    init(radius: Double, color: UIColor, origin: CGPoint) {
        self.circleData = CircleData(radius: radius, color: color, origin: origin)
    }

    var circumference: Double {
        return circleData.radius * Double.pi
    }

    var diameter: Double {
        return circleData.radius * 2
    }

    func draw(graphics: Data) {
    }
}
```

## Usage

```swift
let circle = Circle(radius: 3.0, color: .red, origin: .zero)
print(circle.circumference)
```
