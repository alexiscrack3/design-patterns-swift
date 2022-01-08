# Strategy

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

## Example

```swift
class SaveFileDialog {
    private let strategy: Strategy

    init(strategy: Strategy) {
        self.strategy = strategy
    }

    func save(_ fileName: String) {
        let path = strategy.save(fileName)
        print("Saved in \(path)")
    }
}

protocol Strategy {
    func save(_ fileName: String) -> String
}

class DocFileStrategy: Strategy {
    func save(_ fileName: String) -> String {
        return "\(fileName).doc"
    }
}

class TextFileStrategy: Strategy {
    func save(_ fileName: String) -> String {
        return "\(fileName).txt"
    }
}
```

## Usage

```swift
let docFile = SaveFileDialog(strategy: DocFileStrategy())
docFile.save("file")

let textFile = SaveFileDialog(strategy: TextFileStrategy())
textFile.save("file")
```
