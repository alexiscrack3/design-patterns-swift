# Adapter

The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.

## Example

```swift
class XMLParser {
    private let response: XMLResponse

    init(response: XMLResponse) {
        self.response = response
    }

    func parse() -> JSONResponse {
        return JSONResponse()
    }
}

class JSONResponse {
    let value = "[{}]"
}

class XMLResponse {
    let value = "<?xml version=\"1.0\" ?><note></note>"
}

protocol HTTPRequestTarget {
    func request() -> JSONResponse
}

class HTTPClient: HTTPRequestTarget {
    private let adaptee: LegacyHTTPClient

    init(_ adaptee: LegacyHTTPClient) {
        self.adaptee = adaptee
    }

    func request() -> JSONResponse {
        let xmlResponse = adaptee.request()
        let jsonResponse = XMLParser(response: xmlResponse)
        return jsonResponse.parse()
    }
}

class LegacyHTTPClient {
    func request() -> XMLResponse {
        return XMLResponse()
    }
}
```

### Usage

```swift
let adaptee = LegacyHTTPClient()
let adapter = HTTPClient(adaptee)

adapter.request()
```
