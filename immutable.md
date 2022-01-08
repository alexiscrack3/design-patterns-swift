# Immutable

The immutable pattern is used to allow .

## Example

```swift
class ImmutablePerson {
    private var name: String

    init(name: String) {
        self.name = name
    }

    func uppercased() -> String {
        return ImmutablePerson(name: self.name).name.uppercased()
    }
}
```

## Usage

```swift
let person = ImmutablePerson(name: "Foo")
person.uppercased()
```
