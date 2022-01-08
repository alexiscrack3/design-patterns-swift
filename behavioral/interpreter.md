# Interpreter

The interpreter pattern is used to evaluate sentences in a language.

## Example

```swift
class Context {
    var input: String
    var output: Int = 0

    init(input: String) {
        self.input = input
    }
}

protocol Expression {
    func one() -> String
    func four() -> String
    func five() -> String
    func nine() -> String
    func multiplier() -> Int
}

extension Expression {
    func interpret(context: Context) {
        if context.input.count == 0 {
            return
        }

        if context.input.starts(with: nine()) {
            context.output += (9 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 2)
            context.input = String(context.input.suffix(from: index))
        } else if context.input.starts(with: four()) {
            context.output += (4 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 2)
            context.input = String(context.input.suffix(from: index))
        } else if context.input.starts(with: five()) {
            context.output += (5 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 1)
            context.input = String(context.input.suffix(from: index))
        }

        while context.input.starts(with: one()) {
            context.output += (1 * multiplier())
            let index = context.input.index(context.input.startIndex, offsetBy: 1)
            context.input = String(context.input.suffix(from: index))
        }
    }
}

class ThousandExpression: Expression {
    func one() -> String {
        return "M"
    }

    func four() -> String {
        return " "
    }

    func five() -> String {
        return " "
    }

    func nine() -> String {
        return " "
    }

    func multiplier() -> Int {
        return 1000
    }
}

class HundredExpression: Expression {
    func one() -> String {
        return "C"
    }

    func four() -> String {
        return "CD"
    }

    func five() -> String {
        return "D"
    }

    func nine() -> String {
        return "CM"
    }

    func multiplier() -> Int {
        return 100
    }
}

class TenExpression: Expression {
    func one() -> String {
        return "X"
    }

    func four() -> String {
        return "XL"
    }

    func five() -> String {
        return "L"
    }

    func nine() -> String {
        return "XC"
    }

    func multiplier() -> Int {
        return 10
    }
}

class OneExpression: Expression {
    func one() -> String {
        return "I"
    }

    func four() -> String {
        return "IV"
    }

    func five() -> String {
        return "V"
    }

    func nine() -> String {
        return "IX"
    }

    func multiplier() -> Int {
        return 1
    }
}
```

### Usage

```swift
let roman = "MCMXXVIII"
let context = Context(input: roman)

var expressions = Array<Expression>()
expressions.append(ThousandExpression())
expressions.append(HundredExpression())
expressions.append(TenExpression())
expressions.append(OneExpression())

for expression in expressions {
    expression.interpret(context: context)
}
print("\(roman) = \(context.output)")
```
