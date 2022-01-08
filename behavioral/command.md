# Command

The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.

## Example

```swift
enum Operator {
    case plus
    case minus
    case asterisk
    case slash
}

protocol Command {
    func execute()
    func unExecute()
}

class CalculatorCommand: Command {
    let `operator`: Operator
    let operand: Int
    let calculator: Calculator

    init(calculator: Calculator, operator: Operator, operand: Int) {
        self.calculator = calculator
        self.operator = `operator`
        self.operand = operand
    }

    func execute() {
        calculator.operation(operator: `operator`, operand: operand)
    }

    func unExecute() {
        calculator.operation(operator: undo(`operator`), operand: operand)
    }

    private func undo(_ `operator`: Operator) -> Operator {
        switch `operator` {
        case .plus:
            return .minus
        case .minus:
            return .plus
        case .asterisk:
            return .slash
        case .slash:
            return .asterisk
        }
    }
}

class Calculator {
    private var current: Int = 0

    func operation(operator: Operator, operand: Int) {
        switch `operator` {
        case .plus:
            current += operand
        case .minus:
            current -= operand
        case .asterisk:
            current *= operand
        case .slash:
            current /= operand
        }
        print("Current value = \(current) (following \(`operator`) \(operand))")
    }
}

class Computer {
    private var calculator = Calculator()
    private var commands = [Command]()
    private var current = 0

    func redo(levels: Int) {
        print("\n---- Redo \(levels) levels")

        var i = 0
        while i < levels {
            if current < commands.count {
                let command = commands[current]
                current += 1
                command.execute()
            }
            i += 1
        }
    }

    func undo(levels: Int) {
        print("\n---- Undo \(levels) levels")

        var i = 0
        while i < levels {
            if current > 0 {
                current -= 1
                let command = commands[current]
                command.unExecute()
            }
            i += 1
        }
    }

    func compute(_ `operator`: Operator, _ operand: Int) {
        let command = CalculatorCommand(calculator: calculator, operator: `operator`, operand: operand)
        command.execute()
        commands.append(command)
        current += 1
    }
}
```

### Usage

```swift
let computer = Computer()
computer.compute(.plus, 100)
computer.compute(.minus, 50)
computer.compute(.asterisk, 10)
computer.compute(.slash, 2)

computer.undo(levels: 4)

computer.redo(levels: 3)
```

### Output

```text
Current value = 100 (following plus 100)
Current value = 50 (following minus 50)
Current value = 500 (following asterisk 10)
Current value = 250 (following slash 2)

---- Undo 4 levels
Current value = 500 (following asterisk 2)
Current value = 50 (following slash 10)
Current value = 100 (following plus 50)
Current value = 0 (following minus 100)

---- Redo 3 levels
Current value = 100 (following plus 100)
Current value = 50 (following minus 50)
Current value = 500 (following asterisk 10)
```
