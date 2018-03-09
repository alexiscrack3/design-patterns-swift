//: [Previous](@previous)

/*:
 Decorator
 ------------
 
 The decorator pattern is used to extend or alter the functionality of objects at run- time by wrapping them in an object of a decorator class.
 This provides a flexible alternative to using inheritance to modify behaviour.
 
 ### Example
 */
protocol Element {
    func imagePath() -> String
}

class Shape: Element {
    func imagePath() -> String {
        return "Shape.png"
    }
}

class Number: Element {
    func imagePath() -> String {
        return "Number.png"
    }
}

class ElementDecorator: Element {
    private let decoratedElement: Element
    fileprivate let ingredientSeparator: String = ", "
    
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
        return "color/" + super.imagePath()
    }
}

final class SizeDecorator: ElementDecorator {
    required init(decoratedElement: Element) {
        super.init(decoratedElement: decoratedElement)
    }
    
    override func imagePath() -> String {
        return "size/" + super.imagePath()
    }
}
/*:
 ### Usage:
 */
var element: Element = Shape()
print("Path = \(element.imagePath())")
element = ColorDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")
element = SizeDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")

//: [Next](@next)
