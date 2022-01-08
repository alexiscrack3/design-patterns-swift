# Factory Method

The factory method pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.

## Example

```swift
protocol Shoe {
    var price: Double { get set }
    var weight: Float { get set }
    var type: String { get set }
}

protocol Ball {
    var price: Double { get set }
}

struct RunningShoe: Shoe {
    var price: Double
    var weight: Float
    var type: String
}

struct SoccerBall: Ball {
    var price: Double
}

struct BasketballBall: Ball {
    var price: Double
}

protocol SportsFactory {
    func makeShoe() -> Shoe
    func makeSoccerBall() -> Ball
    func makeBasketballBall() -> Ball
}

class NikeFactory: SportsFactory {
    func makeShoe() -> Shoe {
        return RunningShoe(price: 100.0, weight: 11.4, type: "Neutral")
    }

    func makeSoccerBall() -> Ball {
        return SoccerBall(price: 80)
    }

    func makeBasketballBall() -> Ball {
        return BasketballBall(price: 50)
    }
}

class AdidasFactory: SportsFactory {
    func makeShoe() -> Shoe {
        return RunningShoe(price: 200.0, weight: 11.0, type: "Neutral")
    }

    func makeSoccerBall() -> Ball {
        return SoccerBall(price: 100)
    }

    func makeBasketballBall() -> Ball {
        return BasketballBall(price: 60)
    }
}
```

## Usage

```swift
let creators: [SportsFactory] = [NikeFactory(), AdidasFactory()]
for creator in creators {
    let soccerBall = creator.makeSoccerBall()
    let basketballBall = creator.makeBasketballBall()
    print(soccerBall.price)
    print(basketballBall.price)
}
```
