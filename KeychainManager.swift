//
//  KeychainManager.swift
//  Prototype class to illustrated interaction with the user's MacOS Keychain.
//
//  Created by Michael Miranda on 4/9/24.
//

import Foundation


class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
        case noPassword
        
    }
    
    static func save(service: String, account: String, password: Data) throws {
        let query: [String: AnyObject] = [
            //kSecUseKeychain as String: "login" as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func retrieve(service: String, account: String) -> Data? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        
        print(status)
        
        return result as? Data
    }
    
    static func update(service: String, account: String, password: Data) throws {
            
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject
            ]
            
            let attributes: [String: AnyObject] = [
                kSecAttrAccount as String: account as AnyObject,
                kSecValueData as String: password as AnyObject
            ]
            
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            guard status != errSecItemNotFound else { throw KeychainError.noPassword }
            guard status == errSecSuccess else { throw KeychainError.unknown(status) }
            print("Updated")
        }
    
}

