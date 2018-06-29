//: [Behavioral](Behavioral) |
//: [Creational](Creational) |
//: Structural
/*:
 Structural
 ==========
 
 >In software engineering, structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
 >
 >**Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Structural_pattern)
 */
import Swift
import Foundation
/*:
 🔌 Adapter
 ----------
 
 The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.
 
 ### Example
 */

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
/*:
 ### Usage
 */
let adaptee = LegacyHTTPClient()
let adapter = HTTPClient(adaptee: adaptee)

adapter.request()
/*:
 Composite
 ----------
 
 The composite pattern is used to create hierarchical, recursive tree structures of related objects where any element of the structure may be accessed and utilised in a standard manner.
 
 ### Example
 */
enum ValidatorResult {
    case valid
    case invalid(error: Error)
}

protocol Validator {
    func validate(_ value: String) -> ValidatorResult
}

enum EmailValidatorError: Error {
    case empty
    case invalidFormat
}

enum PasswordValidatorError: Error {
    case empty
    case tooShort
    case noUppercaseLetter
    case noLowercaseLetter
    case noNumber
}

struct EmptyStringValidator: Validator {
    // This error is passed via the initializer to allow this validator to be reused
    private let invalidError: Error
    
    init(invalidError: Error) {
        self.invalidError = invalidError
    }
    
    func validate(_ value: String) -> ValidatorResult {
        if value.isEmpty {
            return .invalid(error: invalidError)
        } else {
            return .valid
        }
    }
}

struct EmailFormatValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        let magicEmailRegexStolenFromTheInternet = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", magicEmailRegexStolenFromTheInternet)
        
        if emailTest.evaluate(with: value) {
            return .valid
        } else {
            return .invalid(error: EmailValidatorError.invalidFormat)
        }
    }
}

struct PasswordLengthValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        if value.count >= 8 {
            return .valid
        } else {
            return .invalid(error: PasswordValidatorError.tooShort)
        }
    }
}

struct UppercaseLetterValidator: Validator {
    func validate(_ value: String) -> ValidatorResult {
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        
        let uppercaseLetterTest = NSPredicate(format:"SELF MATCHES %@", uppercaseLetterRegex)
        
        if uppercaseLetterTest.evaluate(with: value) {
            return .valid
        } else {
            return .invalid(error: PasswordValidatorError.noUppercaseLetter)
        }
    }
}

struct CompositeValidator: Validator {
    private let validators: [Validator]
    
    init(validators: Validator...) {
        self.validators = validators
    }
    
    func validate(_ value: String) -> ValidatorResult {
        for validator in validators {
            switch validator.validate(value) {
            case .valid:
                break
            case .invalid(let error):
                return .invalid(error: error)
            }
        }
        return .valid
    }
}

struct ValidatorConfigurator {
    static let shared = ValidatorConfigurator()
    
    func emailValidator() -> Validator {
        return CompositeValidator(validators: emptyEmailStringValidator(),
                                  EmailFormatValidator())
    }
    
    func passwordValidator() -> Validator {
        return CompositeValidator(validators: emptyPasswordStringValidator(),
                                  passwordStrengthValidator())
    }
    
    private func emptyEmailStringValidator() -> Validator {
        return EmptyStringValidator(invalidError: EmailValidatorError.empty)
    }
    
    private func emptyPasswordStringValidator() -> Validator {
        return EmptyStringValidator(invalidError: PasswordValidatorError.empty)
    }
    
    private func passwordStrengthValidator() -> Validator {
        return CompositeValidator(validators: PasswordLengthValidator(),
                                  UppercaseLetterValidator())
    }
}
/*:
 ### Usage:
 */
let validatorConfigurator = ValidatorConfigurator.shared
let emailValidator = validatorConfigurator.emailValidator()
let passwordValidator = validatorConfigurator.passwordValidator()

print(emailValidator.validate(""))
print(emailValidator.validate("invalidEmail@"))
print(emailValidator.validate("validEmail@validDomain.com"))

print(passwordValidator.validate(""))
print(passwordValidator.validate("psS$"))
print(passwordValidator.validate("passw0rd"))
print(passwordValidator.validate("paSSw0rd"))
/*:
 Decorator
 ----------
 
 The decorator pattern is used to extend or alter the functionality of objects at run- time by wrapping them in an object of a decorator class.
 This provides a flexible alternative to using inheritance to modify behaviour.
 
 ### Example
 */
protocol Element {
    func imagePath() -> String
}

class Shape: Element {
    func imagePath() -> String {
        return "shape.png"
    }
}

class Object: Element {
    func imagePath() -> String {
        return "object.png"
    }
}

class ElementDecorator: Element {
    private let decoratedElement: Element
    
    required init(decoratedElement: Element) {
        self.decoratedElement = decoratedElement
    }
    
    func imagePath() -> String {
        return decoratedElement.imagePath()
    }
}

final class ColorDecorator: ElementDecorator {
    required init(decoratedElement: Element) {
        super.init(decoratedElement: decoratedElement)
    }
    
    override func imagePath() -> String {
        return "color-" + super.imagePath()
    }
}

final class SizeDecorator: ElementDecorator {
    required init(decoratedElement: Element) {
        super.init(decoratedElement: decoratedElement)
    }
    
    override func imagePath() -> String {
        return "size-" + super.imagePath()
    }
}
/*:
 ### Usage:
 */
var element: Element = Shape()
print("Path = \(element.imagePath())")
element = ColorDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")
element = SizeDecorator(decoratedElement: element)
print("Path = \(element.imagePath())")
