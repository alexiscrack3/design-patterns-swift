# Protection Proxy

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. Protection proxy is restricting access.

## Example

```swift
struct Resource {
    let id: String
}

protocol Authenticable {
    func getResourceById(_ id: String) -> Resource?
}

class ResourceManager: Authenticable {
    let resources = [Resource(id: "1"), Resource(id: "2"), Resource(id: "3")]
    func getResourceById(_ id: String) -> Resource? {
        return self.resources.first(where: { $0.id == id })
    }
}

class VaultManager: Authenticable {
    private var resourceManager: ResourceManager!

    func authenticate(password: String) -> Bool {
        guard password == "pass" else {
            return false
        }

        resourceManager = ResourceManager()

        return true
    }

    func getResourceById(_ id: String) -> Resource? {
        guard resourceManager != nil else {
            return nil
        }

        return resourceManager.getResourceById(id)
    }
}
```

### Usage

```swift
let vaultManager = VaultManager()
_ = vaultManager.getResourceById("123")

_ = vaultManager.authenticate(password: "pass")
_ = vaultManager.getResourceById("1")
```
