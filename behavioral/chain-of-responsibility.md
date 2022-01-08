# Chain of Responsibility

The chain of responsibility pattern is used to process varied requests, each of which may be dealt with by a different handler.

## Example

```swift
enum Denomination: Int {
    case ten = 10
    case twenty = 20
    case fifty = 50
    case oneHundred = 100
}

class MoneyPile {
    let denomination: Denomination
    var quantity: Int
    var nextPile: MoneyPile?

    init(denomination: Denomination, quantity: Int, nextPile: MoneyPile?) {
        self.denomination = denomination
        self.quantity = quantity
        self.nextPile = nextPile
    }

    func canWithdraw(amount: Int) -> Bool {
        var amount = amount

        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.denomination.rawValue) > 0
        }

        var quantity = self.quantity

        while canTakeSomeBill(want: amount) {
            if quantity == 0 {
                break
            }

            amount -= self.denomination.rawValue
            quantity -= 1
        }

        guard amount > 0 else {
            return true
        }

        if let next = self.nextPile {
            return next.canWithdraw(amount: amount)
        }

        return false
    }
}

class ATM {
    private var hundred: MoneyPile
    private var fifty: MoneyPile
    private var twenty: MoneyPile
    private var ten: MoneyPile

    private var startPile: MoneyPile {
        return self.hundred
    }

    init(hundred: MoneyPile, fifty: MoneyPile,
         twenty: MoneyPile, ten: MoneyPile) {
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }

    func canWithdraw(amount: Int) -> String {
        return "Can withdraw: \(self.startPile.canWithdraw(amount: amount))"
    }
}
```

### Usage

```swift
// Create piles of money and link them together 10 < 20 < 50 < 100.**
let ten = MoneyPile(denomination: .ten, quantity: 6, nextPile: nil)
let twenty = MoneyPile(denomination: .twenty, quantity: 2, nextPile: ten)
let fifty = MoneyPile(denomination: .fifty, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(denomination: .oneHundred, quantity: 1, nextPile: fifty)

var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
print(atm.canWithdraw(amount: 310)) // Cannot because ATM has only 300
print(atm.canWithdraw(amount: 100)) // Can withdraw - 1x100
print(atm.canWithdraw(amount: 165)) // Cannot withdraw because ATM doesn't has bill with value of 5
print(atm.canWithdraw(amount: 30))  // Can withdraw - 1x20, 2x10
```
