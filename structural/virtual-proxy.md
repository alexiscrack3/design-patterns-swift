# Virtual Proxy

The virtual proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. Virtual proxy is used for loading object on demand.

## Example

```swift
protocol Imageable {
    func render() -> UIImage
}

public class RealImage: Imageable {
    private var image: UIImage!

    init(url: URL) {
        loadImageURL(url)
    }

    private func loadImageURL(_ url: URL) {
        image = UIImage()
    }

    func render() -> UIImage {
        return image
    }
}

class ProxyImage: Imageable {
    private let url: URL
    private lazy var realImage = RealImage(url: self.url)

    init(url: URL) {
        self.url = url
    }

    func render() -> UIImage {
        return realImage.render()
    }
}
```

### Usage

```swift
let proxyImage = ProxyImage(url: URL(string: "")!)
_ = proxyImage.render()
```
