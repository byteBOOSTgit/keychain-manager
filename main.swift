//
//  main.swift
//  KeychainInteractor: Proof of concept code to demonstrate use and interaction with
//  the class KeychainManager to interact with the user's MacOS Keychain.
//
//  Created by Michael Miranda on 4/9/24.
//

import Foundation


let service = "testService"
let account = "testAccount"
let password = "testPassword".data(using: .utf8)

print("Testing Keychain")
// convert string to a Data object
let p = "testpwd".data(using: .utf8)!

// test saving a password into the Keychain.  This is stored in the
// login Keychain
do {
    try KeychainManager.save(service: service, account: account, password: password!)
} catch {
    print("Unable to add entry.  Likely a duplicate key entry exists in the keychain.")
}

print("Retrieving the username and password from the keychain using the service and account name")
// retrieve the password based on the service and account names
guard let rp = KeychainManager.retrieve(service: service, account: account)
else {
    print("Failed to get password!")
    exit(0)
}
// decode and print the retrieved password
let srp = String(decoding: rp, as: UTF8.self)
print("Password \(srp)")
