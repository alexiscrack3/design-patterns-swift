# State

The state pattern is used to alter the behaviour of an object as its internal state changes. The pattern allows the class for an object to apparently change at run-time.

## Example

```swift
class AppContext {
    private var state: State = UnauthorizedState()

    var isAuthorized: Bool {
        return state.isAuthorized(context: self)
    }

    var userId: String? {
        return state.userId(context: self)
    }

    func changeStateToAuthorized(userId: String) {
        state = AuthorizedState(userId: userId)
    }

    func changeStateToUnauthorized() {
        state = UnauthorizedState()
    }
}

protocol State {
    func isAuthorized(context: AppContext) -> Bool
    func userId(context: AppContext) -> String?
}

class UnauthorizedState: State {
    func isAuthorized(context: AppContext) -> Bool { return false }

    func userId(context: AppContext) -> String? { return nil }
}

class AuthorizedState: State {
    let userId: String

    init(userId: String) { self.userId = userId }

    func isAuthorized(context: AppContext) -> Bool { return true }

    func userId(context: AppContext) -> String? { return userId }
}
```

### Usage

```swift
let appContext = AppContext()
print(appContext.userId ?? "")
appContext.changeStateToAuthorized(userId: "admin")
print(appContext.userId ?? "")
appContext.changeStateToUnauthorized()
print(appContext.userId ?? "")
```
