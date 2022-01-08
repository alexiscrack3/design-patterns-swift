# Façade

The facade pattern is used to define a simplified interface to a more complex subsystem.

## Example

```swift
protocol FlightBooking {
    func book()
}

class FlightBookingSystem: FlightBooking {
    func book() {
        print("Flight booked successfully")
    }
}

protocol HotelBooking {
    func book()
}

class HotelBookingSystem: HotelBooking {
    func book() {
        print("Hotel booked successfully")
    }
}

protocol TrasferBooking {
    func book()
}

class TrasferBookingSystem: TrasferBooking {
    func book() {
        print("Transfer booked successfully")
    }
}

protocol TravelPackage {
    func book()
}

class TravelPackageFacade: TravelPackage {
    func book() {
        let trasferBooking = TrasferBookingSystem()
        trasferBooking.book()

        let hotelBooking = HotelBookingSystem()
        hotelBooking.book()

        let flightBooking = FlightBookingSystem()
        flightBooking.book()

        print("Travel package booked successfully")
    }
}
```

### Usage

```swift
let travelPackage = TravelPackageFacade()
travelPackage.book()
```

### Output

```text
Transfer booked successfully
Hotel booked successfully
Flight booked successfully
Travel package booked successfully
```
