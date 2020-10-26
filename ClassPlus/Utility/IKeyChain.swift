//
//  IKeyChain.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import Foundation
class IKeyChain {
    
    private init(){}
    
    private static var sharedInstance: IKeyChain?
    
    static var shared: IKeyChain {
        guard let sharedInstance = sharedInstance else {
            let sharedInstance = IKeyChain()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    var isLogedIn: Bool {
        if load(key: AppConstants.UserInfo.key) != nil {
            return true
        }
        return false
    }
    
    func save(key: String, data: Data) -> OSStatus {
        let query = [kSecClass as String : kSecClassGenericPassword as String,
                     kSecAttrAccount as String : key,
                     kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    
    func delete(key: String) {
        let query = [kSecClass as String : kSecClassGenericPassword as String,
                     kSecAttrAccount as String : key]
        let status = SecItemDelete(query as CFDictionary)
        print(status.description)
        
    }
}

extension Data {
    
    static func archivedData(from object: Any)-> Data? {
        do {
            return  try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func unarchivedObject()-> Any? {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self)
        }catch let error {
            print(error)
        }
        return nil
    }
    
}

