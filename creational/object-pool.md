# Object Pool

The object pool pattern can offer a significant performance boost; it is most effective in situations where the cost of initializing a class instance is high, the rate of instantiation of a class is high, and the number of instantiations in use at any one time is low.

## Example

```swift
struct MagicObject {
    let name: String
    let serialNumber: Int
    var occupier: [String] = []
    var borrowedCount: Int = 0
}

class Pool<T> {
    var magicObjects = [T]()
    private let arrayQ = DispatchQueue(label: "array")
    private let semaphore: DispatchSemaphore

    init(items: [T]) {
        magicObjects.reserveCapacity(magicObjects.count)
        for item in items {
            magicObjects.append(item)
        }
        // create a counter semaphore for the available items in the pool
        semaphore = DispatchSemaphore(value: items.count)
    }

    func getFromPool() -> T? {
        var result: T?
        // the semaphore count is decreased each time when the wait is called. If the count is 0, the function will block
        if semaphore.wait(timeout: .distantFuture) == DispatchTimeoutResult.success {
            if magicObjects.count > 0 {
                arrayQ.sync {
                    result = self.magicObjects.remove(at: 0)
                }
            }
        }
        return result
    }

    func returnToPool(item: T) {
        arrayQ.sync {
            self.magicObjects.append(item)
            // increase the counter by 1
            self.semaphore.signal()
            //            DispatchSemaphore.signal(self.semaphore)()
        }
    }
}

extension Int {
    func times(action: (Int)->()) {
        for i in 0..<self {
            action(i)
        }
    }
}
class MagicHouse {
    private let pool: Pool<MagicObject>
    static var sharedInstance = MagicHouse()
    static var magicDebtInfo: [(String, Int, String)] = []

    private init() {
        var magicObjects:[MagicObject] = []
        2.times {
            magicObjects.append(MagicObject(name: "Red Diamond", serialNumber: $0, occupier: [], borrowedCount: 0))
        }
        3.times {
            magicObjects.append(MagicObject(name: "Blue Heart", serialNumber: $0, occupier: [], borrowedCount: 0))
        }
        self.pool = Pool(items: magicObjects)
    }

    static func lendMagicObject(occupier: String) -> MagicObject? {
        var magicObject = sharedInstance.pool.getFromPool()
        if magicObject != nil {
            magicObject!.occupier.append(occupier)
            magicObject!.borrowedCount += 1
            magicDebtInfo.append((magicObject!.name, magicObject!.serialNumber, occupier))
            print("\(occupier) is borrowing \(magicObject!.name) #\(magicObject!.serialNumber)")
        }
        return magicObject
    }

    static func receiveMagicObject(obj: MagicObject) {
        magicDebtInfo = magicDebtInfo.filter {
            $0.0 != obj.name && $0.1 != obj.serialNumber
        }
        sharedInstance.pool.returnToPool(item: obj)
        print("\(obj.occupier.last!) returning \(obj.name) #\(obj.serialNumber)")
    }

    static func printReport() {
        print("\nShow Report: Magic House currently has \(sharedInstance.pool.magicObjects.count) magic object(s) in stock")
        sharedInstance.pool.magicObjects.forEach {
            print("\($0.name) #\($0.serialNumber) \nBorrowed \($0.borrowedCount) time(s) by \($0.occupier)")
        }

        if magicDebtInfo.count > 0 {
            print("\nMagic Objects currently lent out:")
            magicDebtInfo.forEach {
                print("\($0.0) #\($0.1) by \($0.2)")
            }
        }
    }
}
```

### Usage

```swift
let queue = DispatchQueue(label: "workQ", attributes: .concurrent)
let group = DispatchGroup()

print("\n------Starting test...")

for i in 1...7 {
    queue.async(group: group, execute: DispatchWorkItem(block: {
        if let obj = MagicHouse.lendMagicObject(occupier: "person #\(i)") {
            Thread.sleep(forTimeInterval: Double(arc4random_uniform(10)))
            MagicHouse.receiveMagicObject(obj: obj)
        }
    }))
}

_ = group.wait(timeout: .distantFuture)
_ = MagicHouse.lendMagicObject(occupier: "William")
_ = MagicHouse.lendMagicObject(occupier: "Tato")
MagicHouse.printReport()
```

### Output

```text
------Starting test...
person #4 is borrowing Blue Heart #1
person #1 is borrowing Red Diamond #1
person #6 is borrowing Blue Heart #0
person #2 is borrowing Blue Heart #2
person #5 is borrowing Red Diamond #0
person #7 is borrowing Blue Heart #2
person #2 returning Blue Heart #2
person #7 returning Blue Heart #2
person #3 is borrowing Blue Heart #2
person #1 returning Red Diamond #1
person #5 returning Red Diamond #0
person #6 returning Blue Heart #0
person #4 returning Blue Heart #1
person #3 returning Blue Heart #2
William is borrowing Red Diamond #1
Tato is borrowing Red Diamond #0

Show Report: Magic House currently has 3 magic object(s) in stock
Blue Heart #0
Borrowed 1 time(s) by ["person #6"]
Blue Heart #1
Borrowed 1 time(s) by ["person #4"]
Blue Heart #2
Borrowed 3 time(s) by ["person #2", "person #7", "person #3"]

Magic Objects currently lent out:
Red Diamond #1 by William
Red Diamond #0 by Tato
```
