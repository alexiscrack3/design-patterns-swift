# Composite

The composite pattern is used to create hierarchical, recursive tree structures of related objects where any element of the structure may be accessed and utilised in a standard manner.

## Example

```swift
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
```

## Usage

```swift
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
```
