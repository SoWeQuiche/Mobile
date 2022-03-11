//
//  KeychainValues.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation

/// Allows to match for optionals with generics that are defined as non-optional.
private protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

public struct KeychainValues {
    public static var standard = KeychainValues(container: KeychainWrapper())

    private var container: KeychainAccess

    public init(container: KeychainAccess) {
        self.container = container
    }

    public subscript<Key>(key: Key) -> Key.Value where Key: KeychainKey {
        get {
            guard let encoded = container.read(key: key) else {
                return Key.defaultValue
            }
            do {
                return try JSONDecoder().decode(Key.Value.self, from: encoded)
            } catch {
                print(error)
                return Key.defaultValue
            }
        }

        set {
            if let optionalNewValue = newValue as? AnyOptional, optionalNewValue.isNil {
                _ = container.delete(key: key)
            } else {
                do {
                    let data = try JSONEncoder().encode(newValue)
                    _ = container.save(key: key, value: data)
                } catch {
                    print(error)
                }
            }
        }
    }
}

@propertyWrapper public struct Keychained<Key: KeychainKey> {
    public struct ConfigurationContainer {
        public var key: Key
        public var values: KeychainValues
    }

    // MARK: - Attributes
    private(set) var key: Key
    var values: KeychainValues

    public var wrappedValue: Key.Value {
        get { values[key] }

        set { values[key] = newValue }
    }

    // MARK: - Initializers

    public var projectedValue: ConfigurationContainer {
        get {
            ConfigurationContainer(key: key, values: values)
        }
        set {
            self.key = newValue.key
            self.values = newValue.values
        }
    }

    public init(key: Key, values: KeychainValues = .standard) {
        self.key = key
        self.values = values
    }
}
