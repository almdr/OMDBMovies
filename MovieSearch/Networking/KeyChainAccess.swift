//
//  KeyChainAccess.swift
//
//

import UIKit
import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"

/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let passwordKey = "KeyForPassword"
let touchIDKey = "TouchIDValue"
let encryptedKey = "KeyForEncryption"
let aesivKey = "KeyForAES_IV"
let jwtToken = "KeyForJwtToken"
let userSecurityDetails = "KeySecurityDetails"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)


public class KeyChainAccess: NSObject
{
    public class func savePassword(token: NSString) {
        self.save(service: passwordKey as NSString, data: token)
    }
    public class func loadPassword() -> NSString? {
        return self.load(service: passwordKey as NSString)
    }
    public class func saveTouchIdValue(token: NSString) {
        self.save(service: touchIDKey as NSString, data: token)
    }
    public class func loadTouchIdValue() -> NSString? {
        return self.load(service: touchIDKey as NSString)
    }
    public class func saveEncryptionKey(token: NSString) {
        self.save(service: encryptedKey as NSString, data: token)
    }
    public class func loadEncryptionKey() -> NSString? {
        return self.load(service: encryptedKey as NSString)
    }
    public class func saveAESIV(token: NSString) {
        self.save(service: aesivKey as NSString, data: token)
    }
    public class func loadAESIV() -> NSString? {
        return self.load(service: aesivKey as NSString)
    }
    
    public class func saveJwtToken(jwt: String) {
        self.save(service: jwtToken as NSString, data: jwt as NSString)
    }
    
    public class func loadJwtToken() -> String {
        return (self.load(service: jwtToken as NSString) ?? "") as String
    }
    
    public class func removeJwtToken() {
        self.remove(service: jwtToken as NSString)
    }
    
    public class func saveSecurityData(dict: Dictionary<String, Any>) {
        guard !dict.isEmpty, let data = NSKeyedArchiver.archivedData(withRootObject: dict) as NSData? else { return }
        self.saveData(service: userSecurityDetails as NSString, data: data)
    }
    
    public class func loadSecurityData() -> Dictionary<String, Any> {
        if let data = self.loadData(service: userSecurityDetails as NSString) as? Data,
        let dict = NSKeyedUnarchiver.unarchiveObject(with: data as Data ) {
            return (dict as? [String: Any]) ?? [:]
        }
        return [:]
    }
    
    public class func removeSecurityData() {
        self.remove(service: userSecurityDetails as NSString)
    }
    
    /**
     * Internal methods for querying the keychain.
     */
    private class func save(service: NSString, data: NSString) {
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    /**
     * Internal methods for saving data into the keychain.
     */
    private class func saveData(service: NSString, data: NSData) {
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, data], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    /**
     * Internal methods for remove keychain item
     */
    private class func remove(service: NSString) {
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        
        // Delete any existing items
        DispatchQueue.main.async {
            SecItemDelete(keychainQuery as CFDictionary)
        }
    }
    
    private class func load(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        var dataTypeRef: AnyObject?
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        }
        return contentsOfKeychain
    }
    
    private class func loadData(service: NSString) -> NSData? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        var dataTypeRef: AnyObject?
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSData? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = retrievedData
            }
        }
        return contentsOfKeychain
    }
}

public class Keychain: NSObject {
  public class func logout()  {
    let secItemClasses =  [
      kSecClassGenericPassword,
      kSecClassInternetPassword,
      kSecClassCertificate,
      kSecClassKey,
      kSecClassIdentity,
    ]
    for itemClass in secItemClasses {
      let spec: NSDictionary = [kSecClass: itemClass]
      SecItemDelete(spec)
    }
  }
}
