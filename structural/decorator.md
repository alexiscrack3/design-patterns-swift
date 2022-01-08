# Decorator

The decorator pattern is used to extend or alter the functionality of objects at run- time by wrapping them in an object of a decorator class. This provides a flexible alternative to using inheritance to modify behaviour.

## Example

```swift
protocol Element {
    func imagePath() -> String
}

class Shape: Element {
    func imagePath() -> String {
        return "shape.png"
    }
}

class Object: Element {
    func imagePath() -> String {
        return "object.png"
    }
}

class ElementDecorator: Element {
    private let decoratedElement: Element

    required init(decoratedElement: Element) {
        self.decoratedElement = decoratedElement
    }

    func imagePath() -> String {
        return decoratedElement.imagePath()
    }
}

final class ColorDecorator: ElementDecorator {
    required init(decoratedElement: Element) {
        super.init(decoratedElement: decoratedElement)
    }

    override func imagePath() -> String {
        return "color-" + super.imagePath()
    }
}

final class SizeDecorator: ElementDecorator {
    required init(decoratedElement: Element) {
        super.init(decoratedElement: decoratedElement)
    }

    override func imagePath() -> String {
        return "size-" + super.imagePath()
    }
}
```

### Usage

```swift
var element: Element = Shape()
print("Path = \(element.imagePath())")
element = ColorDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")
element = SizeDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")
```

### Output

```text
Path = shape.png
Path = color-shape.png
Path = size-color-shape.png
```
