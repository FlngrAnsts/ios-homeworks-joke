//
//  QuoteViewModel.swift
//  Joke
//
//  Created by Anastasiya on 01.08.2024.
//

import Foundation
import RealmSwift
//import Security

class QuoteManager {
    
    static func getKey() -> Data {
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }
        
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }

    
    static func realmInstance() -> Realm {
        let config = Realm.Configuration(encryptionKey: getKey())
        
        return try! Realm(configuration: config)
    }
    
    static func addQuote (quote: Quote) {
        let realm = realmInstance()
        
        try! realm.write {
            realm.add(QuoteRealm(quote: quote))
        }
    }
    
    static func listQuote() -> [QuoteRealm] {
        let realm = realmInstance()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        return quotesRealm.map({ $0 })
    }
    
    static func getCategorys() -> [String] {
        let realm = realmInstance()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        var allCategory = [String]()
        quotesRealm.forEach { quote in
            quote.categories.forEach { category in
                allCategory.append(category)
            }
        }
        allCategory.append("No Category")
        return Array(Set(allCategory))
    }
    
    static func getQuoteForCategory(category: String) -> [QuoteRealm] {
        let realm = realmInstance()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        let allQuote = quotesRealm.filter({
            if category == "No Category"{
                $0.categories.isEmpty
            }else{
                $0.categories.contains(category)
            }
        })
        return allQuote.map({ $0 })
    }
    
    
    }
