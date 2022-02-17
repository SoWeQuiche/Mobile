//
//  KeychainAccess.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 17/02/2022.
//

import Foundation

public protocol KeychainAccess {
    func save<Key: KeychainKey>(key: Key, value: Data) -> Bool
    func delete<Key: KeychainKey>(key: Key) -> Bool
    func read<Key: KeychainKey>(key: Key) -> Data?
    func resetKeychain() -> Bool
}

fileprivate extension KeychainKey {
    var account: String {
        "\(scope)_\(Self.keyString)"
    }
}

/**
 A handy Keychain wrapper. It saves your OAuth2 tokens using WhenPasscodeSet ACL.
 */
public class KeychainWrapper: KeychainAccess {

    /**
     The service id. By default set to apple bundle id.
     */
    var serviceIdentifier: String

    /**
     Initialize KeychainWrapper setting default values.

     :param: serviceId unique service, defaulted to bundleId
     :param: groupId used for SSO between app issued from same developer certificate.
     */
    public init(serviceId: String? = Bundle.main.bundleIdentifier) {
        if serviceId == nil {
            self.serviceIdentifier = "unknown"
        } else {
            self.serviceIdentifier = serviceId.unsafelyUnwrapped
        }
    }

    /**
     Save tokens information in Keychain.

     :param: key usually use accountId for OAuth2 module, any unique string.
     :param: tokenType type of token: access, refresh.
     :param: value string value of the token.
     */
    public func save<Key: KeychainKey>(key: Key, value: Data) -> Bool {
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = kSecClassGenericPassword
        keychainQuery[kSecAttrService as String] = self.serviceIdentifier
        keychainQuery[kSecAttrAccount as String] = key.account
        keychainQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        // Search for the keychain items
        let statusSearch: OSStatus = SecItemCopyMatching(keychainQuery, nil)

        // if found update
        if statusSearch == errSecSuccess {
            let attributesToUpdate = NSMutableDictionary()
            attributesToUpdate[kSecValueData as String] = value

            let statusUpdate: OSStatus = SecItemUpdate(keychainQuery, attributesToUpdate)
            if statusUpdate != errSecSuccess {
//                AppLog.error("tokens not updated")
                return false
            } else {
//                AppLog.debug("\(key.account) saved")
            }
        } else if statusSearch == errSecItemNotFound { // if new, add
            keychainQuery[kSecValueData as String] = value
            let statusAdd: OSStatus = SecItemAdd(keychainQuery, nil)
            if statusAdd != errSecSuccess {
//                AppLog.error("tokens not saved")
                return false
            } else {
//                AppLog.debug("\(key.account) saved")
            }
        } else { // error case
            return false
        }

        return true
    }

    /**
     Delete a specific token in Keychain.

     :param: key usually use accountId for oauth2 module, any unique string.
     :param: tokenType type of token.
     */
    public func delete<Key: KeychainKey>(key: Key) -> Bool {
        let keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = kSecClassGenericPassword
        keychainQuery[kSecAttrService as String] = self.serviceIdentifier
        keychainQuery[kSecAttrAccount as String] = key.account
        keychainQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let statusDelete: OSStatus = SecItemDelete(keychainQuery)

        return statusDelete == noErr
    }

    /**
     Read tokens information in Keychain. If the entry is not found return nil.

     :param: userAccount key of the keychain entry, usually accountId for oauth2 module.
     :param: tokenType type of token: access, refresh.
     */
    public func read<Key: KeychainKey>(key: Key) -> Data? {
        let keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = kSecClassGenericPassword
        keychainQuery[kSecAttrService as String] = self.serviceIdentifier
        keychainQuery[kSecAttrAccount as String] = key.account
        keychainQuery[kSecMatchLimit as String] = kSecMatchLimitOne
        keychainQuery[kSecReturnData as String] = kCFBooleanTrue
        keychainQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        var dataTypeRef: AnyObject?
        // Search for the keychain items
        let status: OSStatus = withUnsafeMutablePointer(to: &dataTypeRef) {
            SecItemCopyMatching(keychainQuery as CFDictionary, UnsafeMutablePointer($0))
        }

        if status == errSecItemNotFound {
//            AppLog.warning("\(key.account) not found")
            return nil
        } else if status != errSecSuccess {
//            AppLog.error("Error attempting to retrieve \(key.account) with error code \(status)")
            return nil
        }

        guard let keychainData = dataTypeRef as? Data else {
            return nil
        }

        return keychainData
    }

    /**
     Clear all keychain entries. Note that Keychain can only be cleared programmatically.
     */
    public func resetKeychain() -> Bool {
        return self.deleteAllKeysForSecClass(secClass: kSecClassGenericPassword) &&
            self.deleteAllKeysForSecClass(secClass: kSecClassInternetPassword) &&
            self.deleteAllKeysForSecClass(secClass: kSecClassCertificate) &&
            self.deleteAllKeysForSecClass(secClass: kSecClassKey) &&
            self.deleteAllKeysForSecClass(secClass: kSecClassIdentity)
    }

    // MARK: Private

    private func deleteAllKeysForSecClass(secClass: CFTypeRef) -> Bool {
        let keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = secClass
        let result: OSStatus = SecItemDelete(keychainQuery)
        if result == errSecSuccess {
            return true
        } else {
            return false
        }
    }
}
