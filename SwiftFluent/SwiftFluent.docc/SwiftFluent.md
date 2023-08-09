# SwiftFluent Documentation

## Table of Contents

- [Quickstart Guide](#quickstart-guide)
- [Introduction](#introduction)
- [Initializer](#initializer)
- [Adding Validation Rules](#adding-validation-rules)
- [Performing Validation](#performing-validation)
- [Validation Errors](#validation-errors)
- [Additional Validation Information](#additional-validation-information)

### **Quickstart Guide**

SwiftFluent is a powerful validation framework for Swift applications. With intuitive APIs, it empowers developers to easily define and enforce data validation rules. Whether it's ensuring data integrity, validating user inputs, or handling complex validation logic, SwiftFluent simplifies the process while maintaining flexibility.

Example - Initializing Validator for `User` object:

```swift
// Import SwiftFluent
import SwiftFluent

// Define a User struct
struct User {
    var name: String
    var age: Int
    var profileImageURL: URL?
    var email: String?
}

// Create a Validator instance
let validator = Validator<User>()
    .ruleFor(\.name)
    .notEmpty()
    .maxLength(50)
    .ruleFor(\.age)
    .range(18...100)
    .ruleFor(\.profileImageURL)
    .notNil()
    .ruleFor(\.email)
    .email()
    .build()
```

Get started with SwiftFluent to streamline your data validation process with ease and precision.

## Introduction

The `Validator` class is a fundamental component of SwiftFluent, responsible for managing and executing validation rules on objects of type `Model`. It allows you to ensure that your data adheres to specific constraints, making it a valuable tool for validating user input and maintaining data integrity.

## Initializer

To create an instance of the `Validator` class, use the default initializer:

```swift
let validator = Validator<Model>()
```


## Adding Validation Rules

Validation can be seamlessly integrated either by chaining default validators or by attaching custom validators using the `validate` method:

### Chaining Default Validators

```swift
let validator = Validator<User>()
    .ruleFor(\.username).notEmpty()
    .ruleFor(\.email).email()
    // Add more default validation rules as needed
```

### Adding Custom Validators

```swift
let customValidator = ValidationRule<User>(...) // Define your custom validation rule
let validator = Validator<User>()
    .validate(customValidator)
    // Add more custom validation rules as needed
```

Opt for the approach that suits your validation requirements.

## Performing Validation

To perform validation on a specific `Model`, call the `validate(_:)` method of the `Validator` instance:

```swift
let user = User(username: "john_doe", email: "john.doe@example.com")
let validationResult = validator.validate(user)

switch validationResult {
case .valid:
    print("Validation succeeded.")
case .invalid(let errors):
    print("Validation failed with errors:")
    for error in errors {
        print("- \(error)")
    }
}
```

## Validation Errors

After validation, you can access the validation errors in the `validationErrors` property of the `Validator` instance. The errors are stored as an array of strings:

```swift
let validator = Validator<User>()
let user = User(username: "john_doe", email: "invalid_email")
let validationResult = validator.validate(user)

print(validator.validationErrors) // Output: ["Invalid email format."]
```

## Additional Validation Information

### Validation Errors Map

In addition to the `validationErrors`, the `Validator` also maintains a dictionary `validationErrorsMap`, where the keys are property names, and the values are arrays of corresponding error messages. This can be useful for handling validation errors specific to each property.

### Handling Complex Objects

Note: The `Validator` class in SwiftFluent is primarily designed to work with simple types such as strings and integers. However, for more complex objects containing simple types, you can leverage the `ValidationRuleBuilder` class. The `ValidationRuleBuilder` extends the functionality of the `Validator` and makes it easier to handle object validation.

By using the `ValidationRuleBuilder`, you can define validation rules for properties within the complex object. This provides a more convenient way to validate objects that contain multiple simple types.

To use the `ValidationRuleBuilder`, you can chain rule definitions for different properties of the object and specify custom error messages. It allows you to create expressive and organized validation rules for complex objects.

For simple types, you can continue to use the standard `Validator` class as shown in the previous sections. However, when dealing with more intricate structures, the `ValidationRuleBuilder` is the recommended approach.

```swift
// Example usage of ValidationRuleBuilder for a complex object
let validator = Validator<User>()
validator
    .ruleFor(\.email)
    .email(errorMessage: "Invalid email format.")
    .ruleFor(\.username)
    .length(5, 15, errorMessage: "Username must be between 5 and 15 characters.")
    .ruleFor(\.age)
    .min(18, errorMessage: "Age must be at least 18.")
    .max(100, errorMessage: "Age must be less than or equal to 100.")
    .ruleFor(\.address)
    .maxLength(100, errorMessage: "Address must be 100 characters or less.")
    .build()
```

The combined power of the **`Validator`** and **`ValidationRuleBuilder`** allows you to create a robust and flexible validation system for your Swift applications. By ensuring that your data remains valid and consistent throughout its lifecycle, you can enhance the reliability and integrity of your application's data.

Utilizing the **`ValidationRuleBuilder`** is especially beneficial when dealing with complex Swift objects that contain multiple properties with specific validation requirements. It streamlines the validation process, making it easier to maintain and update validation rules as your application evolves.

In summary, the **`ValidationRuleBuilder`** is a valuable addition to the **SwiftFluent** framework, empowering you to handle object validation with ease and efficiency.


### Retrieving Validation Error Messages

#### `errorFor<Value>(keyPath: KeyPath<Model, Value>) -> [String]`

Retrieves the validation error messages for a given property in the model.

- Parameters:
  - `keyPath`: The key path representing the property in the model.
- Returns: An array of validation error messages for the specified property, or empty array if there are no validation errors for the property.

Example usage:
```swift
let validator = Validator<User>()
let user = User(username: "john_doe", email: "invalid_email")
let validationResult = validator.validate(user)

if let errors = validator.errorFor(keyPath: \.email) {
    for error in errors {
        print("- \(error)")
    }
}
```

#### `errorFor<Value>(keyPath: KeyPath<Model, Value>, assign: inout String) -> Validator<Model>`

Retrieves the validation error messages for a given property in the model and updates the provided `errorMessage` with the first error message, if any. This method is used to get the error message associated with a specific property and update an `inout` `errorMessage` parameter for easy access to the error message.

**Parameters**:
- `keyPath`: The key path representing the property in the model.
- `assign`: A reference to a string that will be updated with the first validation error message, if any. If no errors are found, it will be set to an empty string.
  
**Returns**: The `Validator` instance for further chaining of validation rules.

**Example usage**:
```swift
let validator = Validator<User>()
let user = User(username: "john_doe", email: "invalid_email")
let validationResult = validator.validate(user)

var errorMessage = ""
validator.errorFor(keyPath: \.email, assign: &errorMessage)

if !errorMessage.isEmpty {
    print("Validation failed with error: \(errorMessage)")
}
```

### Creating Validation Rules

The `ruleFor<Value>(_ keyPath: KeyPath<Model, Value>) -> ValidationRuleBuilder<Model, Value>` method allows you to create a validation rule for a specific property of the model.

**Parameters**:
- `keyPath`: The key path of the property to validate.

**Returns**: An instance of `ValidationRuleBuilder` that allows chaining validation rules for the specified property.

**Example usage**:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .notEmpty()
    .maxLength(50)
    .build()
```

The `ruleFor` method is utilized to define validation rules for a specific property of the model. It returns a `ValidationRuleBuilder` instance, enabling you to chain multiple validation rules for the same property. Each rule can be specified using methods like `notEmpty`, `maxLength`, `email`, etc.

The `@discardableResult` attribute is employed to suppress the compiler warning when the return value of this method is not used. However, it is recommended to capture the returned `ValidationRuleBuilder` instance to ensure all validation rules are added to the validator.

By leveraging the `ruleFor` method and `ValidationRuleBuilder`, you can easily retrieve validation error messages for specific properties and create comprehensive validation rules for your Swift objects. This ensures data integrity and validity in your applications, enhancing the reliability and accuracy of your data.

---

### `equal(_:errorMessage:)`

Adds a validation rule to check if the value of the property is equal to the specified `value`.

### Parameters

- `value`: The value to compare against the property value.
- `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

### Returns

The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

### Example Usage

```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .equal(25, errorMessage: "Age must be equal to 25.")
    .ruleFor(\.name)
    .equal("John") // Uses the default error message.
```

### Note

If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.

---

### `notEqual(_:errorMessage:)`

Adds a validation rule to check if the value of the property is not equal to the specified `value`.

### Parameters

- `value`: The value that the property should not be equal to.
- `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

### Returns

The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

### Example Usage

```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .notEqual(18, errorMessage: "Age cannot be 18.")
    .ruleFor(\.name)
    .notEqual("John") // Uses the default error message.
```

### Note

If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ should not be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.

---

#### `errorFor<Value>(keyPath: KeyPath<Model, Value>, assign: inout String) -> Validator<Model>`

Retrieves the validation error messages for a given property in the model and updates the provided `errorMessage` with the first error message, if any. This method is used to get the error message associated with a specific property and update an `inout` `errorMessage` parameter for easy access to the error message.

- Parameters:
  - `keyPath`: The key path representing the property in the model.
  - `assign`: A reference to a string that will be updated with the first validation error message, if any. If no errors are found, it will be set to an empty string.

- Returns: The `Validator` instance for further chaining of validation rules.

Example usage:
```swift
let validator = Validator<User>()
let user = User(username: "john_doe", email: "invalid_email")
var errorMessage = ""
validator.errorFor(keyPath: \.email, assign: &errorMessage)
print(errorMessage) // Output: "Invalid email format."
```

With the **`errorFor`** method, you can easily retrieve validation error messages for specific properties in your model and handle them accordingly. The ability to update the **`errorMessage`** parameter in-place allows for efficient and convenient error handling during validation

---

#### `email(customRegex: String?=nil, errorMessage: String?=nil) -> Validator<Model>`
Adds an email validation rule to the Validator. Use this method to add an email validation rule to the Validator. The `email` function checks if the input `Model` contains a valid email address by invoking the `isValidEmail()` function on it.

Example Usage:
```swift
let validator = Validator<String>()
validator.email(errorMessage: "Invalid email format.")
```

---

#### `creditCard(errorMessage: String?=nil) -> Validator<Model>`
Adds a credit card validation rule to the Validator. Use this method to add a credit card validation rule to the Validator. The `creditCard` function checks if the credit card number, represented by the input `Model`, is valid according to the Luhn algorithm using the `CreditCardValidator.isValid(_:)` function.

Example Usage:
```swift
let validator = Validator<String>()
validator.creditCard(errorMessage: "Invalid credit card number.")
```

---

#### `number(errorMessage: String?=nil) -> Validator<Model>`
Adds a number validation rule to the Validator. Use this method to add a number validation rule to the Validator. The `number` function checks if the input `Model` is a valid number using the `isNumber()` function on it.

Example Usage:
```swift
let validator = Validator<String>()
validator.number(errorMessage: "Invalid number.")
```

---

#### `range(_ range: ClosedRange<Int>, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property falls within the specified closed range.

- Parameter range: The closed range within which the property value should lie.
- Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .range(18...65, errorMessage: "Age must be between 18 and 65.")
    .ruleFor(\.experience)
    .range(0...20) // Uses the default error message.
```

---

#### `length(_ min: Int, _ max: Int, errorMessage: String?=nil) -> Validator<Model>`
Extends the Validator type with a method to perform length-based validation on the given model type. This method checks the length of the model's value against the specified `min` and `max` values (inclusive on the minimum end and exclusive on the maximum end). The validation will pass if the length of the model's value is greater than or equal to `min` and less than `max`.

Example Usage:
```swift
let validator = Validator<String>()
validator.length(5, 10, errorMessage: "Length should be between 5 and 9 characters.")
```

#### `minLength(_ length: Int, errorMessage: String?=nil) -> Validator<Model>`
Extends the Validator type with a method to perform minimum length validation on the given model type. This method checks the length of the model's value against the specified `min` value. The validation will pass if the length of the model's value is greater than or equal to `min`.

Example Usage:
```swift
let validator = Validator<String>()
validator.minLength(8, errorMessage: "Minimum length should be 8 characters.")
```

---

#### `maxLength(_ length: Int, errorMessage: String? = nil) -> Validator<Model>`
Extends the Validator type with a method to perform maximum length validation on the given model type. This method checks the length of the model's value against the specified `length` value. The validation will pass if the length of the model's value is less than or equal to `length`.

Example Usage:
```swift
let validator = Validator<String>()
validator.maxLength(15, errorMessage: "Maximum length should be 15 characters.")
```

---

#### `lessThan(_ value: Model, errorMessage: String?=nil) -> Validator<Model>`
Extends the Validator type with a method to perform less-than validation on the given model type. This method checks if the model's value is less than the provided `value`. The validation will pass if the model's value is indeed less than `value`.

Example Usage:
```swift
let validator = Validator<Int>()
validator.lessThan(10, errorMessage: "Value should be less than 10.")
```

---

#### `lessThanOrEqualTo(_ value: Model, errorMessage: String?=nil) -> Validator<Model>`
Extends the Validator type with a method to perform less-than-or-equal-to validation on the given model type. This method checks if the model's value is less than or equal to the provided `value`. The validation will pass if the model's value is less than or equal to `value`.

Example Usage:
```swift
let validator = Validator<Int>()
validator.lessThanOrEqualTo(20, errorMessage: "Value should be less than or equal to 20.")
```

---

#### `greaterThan(_ value: Model, errorMessage: String?=nil) -> Validator<Model>`
Extends the Validator type with a method to perform greater-than validation on the given model type. This method checks if the model's value is greater than the provided `value`. The validation will pass if the model's value is indeed greater than `value`.

Example Usage:
```swift
let validator = Validator<Int>()
validator.greaterThan(5, errorMessage: "Value should be greater than 5.")
```

---

#### `greaterThanOrEqualTo(_ value: Model, errorMessage: String?=nil) -> Validator<Model>`
Extends the Validator type with a method to perform greater-than-or-equal-to validation on the given model type. This method checks if the model's value is greater than or equal to the provided `value`. The validation will pass if the model's value is greater than or equal to `value`.

Example Usage:
```swift
let validator = Validator<Int>()
validator.greaterThanOrEqualTo(15, errorMessage: "Value should be greater than or equal to 15.")
```


## Validation Methods

### `validate(_ model: Model) -> ValidationResult`

Performs validation on the given model using the defined validation rules. The method returns a `ValidationResult` that indicates whether the validation succeeded or failed and provides access to any validation errors, if present.

#### Parameters

- `model`: The model instance to be validated.

#### Return Value

The method returns a `ValidationResult` enum with two possible cases:

- `.valid`: Indicates that the validation succeeded, and the model is valid.
- `.invalid(errors: [String])`: Indicates that the validation failed, and the provided array contains error messages representing the validation errors.

### `errorFor<Value>(keyPath: KeyPath<Model, Value>) -> [String]`

Retrieves the validation error messages for a given property in the model.

#### Parameters

- `keyPath`: The key path representing the property in the model.

#### Return Value

The method returns an array of validation error messages for the specified property, or `nil` if there are no validation errors for the property.

### `errorFor<Value>(keyPath: KeyPath<Model, Value>, assign: inout String) -> Validator<Model>`

Retrieves the validation error messages for a given property in the model and updates the provided `errorMessage` with the first error message, if any. This method is used to get the error message associated with a specific property and update an `inout` `errorMessage` parameter for easy access to the error message.

#### Parameters

- `keyPath`: The key path representing the property in the model.
- `assign`: A reference to a string that will be updated with the first validation error message, if any. If no errors are found, it will be set to an empty string.

#### Return Value

The method returns the `Validator` instance for further chaining of validation rules.

### `ruleFor<Value>(_ keyPath: KeyPath<Model, Value>) -> ValidationRuleBuilder<Model, Value>`

Creates a validation rule for a specific property of the model.

#### Parameters

- `keyPath`: The key path of the property to validate.

#### Return Value

The method returns an instance of `ValidationRuleBuilder` that allows chaining validation rules for the specified property.

#### Example Usage

```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .notEmpty()
    .maxLength(50)
    .build()
```

The `ruleFor` method is used to define validation rules for a particular property of the model. It returns a `ValidationRuleBuilder` instance that allows you to chain multiple validation rules for the same property. Each rule can be specified using methods like `notEmpty`, `maxLength`, `email`, etc.


### `ValidationRuleBuilder` Extension for Equatable Properties

The `ValidationRuleBuilder` extension for Equatable properties provides additional validation rules to check whether the value of a property is equal to a specified value. These rules allow developers to enforce strict equality checks on model properties.

#### `equal(_ value: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is equal to the specified `value`.

- Parameters:
  - `value`: The value to compare against the property value.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .equal(25, errorMessage: "Age must be equal to 25.")
    .ruleFor(\.name)
    .equal("John") // Uses the default error message.
```

- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.

#### `equal(_ value: Value, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is equal to the specified `value`.

- Parameters:
  - `value`: The value to compare against the property value.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .equal(25, errorMessage: "Age must be equal to 25.")
    .ruleFor(\.name)
    .equal("John") // Uses the default error message.
```

- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.


#### `notEqual(_ value: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is not equal to the specified `value`.

- Parameters:
  - value: The value that the property should not be equal to.
  - errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.

Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

##### Example usage:

```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .notEqual(18, errorMessage: "Age cannot be 18.")
    .ruleFor(\.name)
    .notEqual("John") // Uses the default error message.
```

##### Note:

If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ should not be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.

#### `notEqual(_ value: Value, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is not equal to the specified `value`.

- Parameters:
  - value: The value that the property should not be equal to.
  - errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.

Returns: The `Validator` instance to allow further rule definitions for different properties.

##### Example usage:

```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .notEqual(18, errorMessage: "Age cannot be 18.")
    .ruleFor(\.name)
    .notEqual("John") // Uses the default error message.
```

##### Note:

If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ should not be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.


### `notNil(errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is not nil.

- Parameters:
  - errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
.ruleFor(\.name)
.notNil(errorMessage: "Name must not be empty.")
.ruleFor(\.age)
.notNil() // Uses the default error message.
```

Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be nil.". The actual property name will be dynamically inserted into the error message.

### `notNil(errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is not nil.

- Parameters:
  - errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
.ruleFor(\.name)
.notNil(errorMessage: "Name must not be empty.")
.ruleFor(\.age)
.notNil() // Uses the default error message.
```

Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be nil.". The actual property name will be dynamically inserted into the error message.


#### `notEmpty(_ errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is not empty.

- Parameters:
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
.ruleFor(\.name)
.notEmpty(errorMessage: "Name must not be empty.")
.ruleFor(\.email)
.notEmpty() // Uses the default error message.
```

- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be empty.". The actual property name will be dynamically inserted into the error message.

#### `notEmpty(_ errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is not empty.

- Parameters:
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
.ruleFor(\.name)
.notEmpty(errorMessage: "Name must not be empty.")
.ruleFor(\.email)
.notEmpty() // Uses the default error message.
```

- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be empty.". The actual property name will be dynamically inserted into the error message.



### `notNil(errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is not nil.

- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .notNil(errorMessage: "Name must not be empty.")
    .ruleFor(\.age)
    .notNil() // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be nil.". The actual property name will be dynamically inserted into the error message.

### `notNil(errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is not nil.

- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .notNil(errorMessage: "Name must not be empty.")
    .ruleFor(\.age)
    .notNil() // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be nil.". The actual property name will be dynamically inserted into the error message.

### `notEmpty(_ errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is not empty.

- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .notEmpty(errorMessage: "Name must not be empty.")
    .ruleFor(\.email)
    .notEmpty() // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be empty.". The actual property name will be dynamically inserted into the error message.

### `notEmpty(_ errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is not empty.

- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .notEmpty(errorMessage: "Name must not be empty.")
    .ruleFor(\.email)
    .notEmpty() // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be empty.". The actual property name will be dynamically inserted into the error message.

### `lessThan(_ maxValue: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is less than the specified `maxValue`.

- Parameter `maxValue`: The maximum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .lessThan(10, errorMessage: "Age must be less than 10.")
    .ruleFor(\.name)
    .lessThan(100) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.

### `lessThan(_ maxValue: Value, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is less than the specified `maxValue`.

- Parameter `maxValue`: The maximum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .lessThan(10, errorMessage: "Age must be less than 10.")
    .ruleFor(\.name)
    .lessThan(100) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.

### `lessThanOrEqualTo(_ maxValue: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is less than or equal to the specified `maxValue`.

- Parameter `maxValue`: The maximum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .lessThanOrEqualTo(18, errorMessage: "Age must be less than or equal to 18.")
    .ruleFor(\.score)
    .lessThanOrEqualTo(100) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than or equal to 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.

### `lessThanOrEqualTo(_ maxValue: Value, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is less than or equal to the specified `maxValue`.

- Parameter `maxValue`: The maximum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let

 validator = Validator<User>()
    .ruleFor(\.age)
    .lessThanOrEqualTo(18, errorMessage: "Age must be less than or equal to 18.")
    .ruleFor(\.score)
    .lessThanOrEqualTo(100) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than or equal to 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.

### `greaterThan(_ minValue: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is greater than the specified `minValue`.

- Parameter `minValue`: The minimum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .greaterThan(18, errorMessage: "Age must be greater than 18.")
    .ruleFor(\.score)
    .greaterThan(0) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be greater than 'minValue'.". The actual property name and `minValue` will be dynamically inserted into the error message.

### `greaterThan(_ minValue: Value, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is greater than the specified `minValue`.

- Parameter `minValue`: The minimum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .greaterThan(18, errorMessage: "Age must be greater than 18.")
    .ruleFor(\.score)
    .greaterThan(0) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be greater than 'minValue'.". The actual property name and `minValue` will be dynamically inserted into the error message.

### `greaterThanOrEqualTo(_ minValue: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is greater than or equal to the specified `minValue`.

- Parameter `minValue`: The minimum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .greaterThanOrEqualTo(18, errorMessage: "Age must be greater than or equal to 18.")
    .ruleFor(\.score)
    .greaterThanOrEqualTo(0) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be greater than or equal to 'minValue'.". The actual property name and `minValue` will be dynamically inserted into the error message.

### `greaterThanOrEqualTo(_ minValue: Value, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is greater than or equal to the specified `minValue`.

- Parameter `minValue`: The minimum value allowed for the property.
- Parameter `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.
- Returns: The `Validator` instance to allow further rule definitions for different properties.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .greaterThanOrEqualTo(18, errorMessage: "Age must be greater than or equal to 18.")
    .ruleFor(\.score)
    .greaterThanOrEqualTo(0) // Uses the default error message.
```
- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be greater than or equal to 'minValue'.". The actual property name and `minValue` will be dynamically inserted into the error message.


#### `length(_ min: Int, _ max: Int, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the length of the property value falls within the specified range.

- Parameters:
  - `min`: The minimum length allowed for the property value.
  - `max`: The maximum length allowed for the property value.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.email)
    .length(5, 10, errorMessage: "Email must be between 5 and 10 characters.")
    .ruleFor(\.name)
    .length(0, 50) // Uses the default error message.
```

- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The length of ‘\(keyPath.propertyName)’ must be between `min` and `max` characters.". The actual property name and `min`/`max` values will be dynamically inserted into the error message.


#### `length(_ min: Int, _ max: Int, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the length of the property value falls within the specified range.

- Parameters:
  - `min`: The minimum length allowed for the property value.
  - `max`: The maximum length allowed for the property value.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.email)
    .length(5, 10, errorMessage: "Email must be between 5 and 10 characters.")
    .ruleFor(\.name)
    .length(0, 50) // Uses the default error message.
```

- Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The length of ‘\(keyPath.propertyName)’ must be between `min` and `max` characters.". The actual property name and `min`/`max` values will be dynamically inserted into the error message.


### `maxLength(_ max: Int, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the length of the property value is less than or equal to the specified `max` length.

- Parameters:
  - `max`: The maximum allowed length for the property value.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .maxLength(30, errorMessage: "Name must be 30 characters or less.")
    .ruleFor(\.address)
    .maxLength(100) // Uses the default error message.
```

### `maxLength(_ max: Int, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the length of the property value is less than or equal to the specified `max` length.

- Parameters:
  - `max`: The maximum allowed length for the property value.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .maxLength(30, errorMessage: "Name must be 30 characters or less.")
    .ruleFor(\.address)
    .maxLength(100) // Uses the default error message.
```

### `minLength(_ min: Int, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property has a minimum length of `min`.

- Parameters:
  - `min`: The minimum length allowed for the property.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .minLength(5, errorMessage: "Name must have at least 5 characters.")
    .ruleFor(\.email)
    .minLength(8) // Uses the default error message.
```

### `minLength(_ min: Int, errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property has a minimum length of `min`.

- Parameters:
  - `min`: The minimum length allowed for the property.
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.name)
    .minLength(5, errorMessage: "Name must have at least 5 characters.")
    .ruleFor(\.email)
    .minLength(8) // Uses the default error message.
```

### `email(_ customRegex: String? = nil, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds an email validation rule to the builder for the specified property.

- Parameters:
  - `customRegex`: An optional regular expression to customize email validation.
  - `errorMessage`: An optional custom error message to display if validation fails.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.email)
    .email(errorMessage: "Invalid email format.")
    .ruleFor(\.name)
    .email() // Uses the default error message.
```

### `email(_ customRegex: String? = nil, errorMessage: String? = nil) -> Validator<Model>`

Adds an email validation rule to the validator for the specified property.

- Parameters:
  - `customRegex`: An optional regular expression to customize email validation.
  - `errorMessage`: An optional custom error message to display if validation fails.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.email)
    .email(errorMessage: "Invalid email format.")
    .ruleFor(\.name)
    .email() // Uses the default error message.
```

### `creditCard(_ errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is a valid credit card number.

- Parameters:
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.creditCardNumber)
    .creditCard(errorMessage: "Invalid credit card number.")
    .ruleFor(\.name)
    .creditCard() // Uses the default error message.
```

### `creditCard(_ errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is a valid credit card number.

- Parameters:
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.creditCardNumber)
    .creditCard(errorMessage: "Invalid credit card number.")
    .build()
```

### `number(errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value>`

Adds a validation rule to check if the value of the property is a valid number.

- Parameters:
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .number(errorMessage: "Age must be a valid number.")
   

 .ruleFor(\.salary)
    .number() // Uses the default error message.
```

### `number(errorMessage: String? = nil) -> Validator<Model>`

Adds a validation rule to check if the value of the property is a valid number.

- Parameters:
  - `errorMessage`: The error message to display if the validation fails. If not provided, a default error message will be used.

Example usage:
```swift
let validator = Validator<User>()
    .ruleFor(\.age)
    .number(errorMessage: "Age must be a valid number.")
    .ruleFor(\.salary)
    .number() // Uses the default error message.
```

---

### `url(errorMessage:)`

Creates a validation rule builder for validating URLs.

- Parameters:
    - `errorMessage`: An optional error message to be associated with this validation rule.

**Returns:**

A `ValidationRuleBuilder` instance configured for building URL validation rules.

**Example:**

```swift
let validator = Validator<User>()
    .ruleFor(\.profileImageURL)
    .url(errorMessage: "Invalid URL format")
```

---
