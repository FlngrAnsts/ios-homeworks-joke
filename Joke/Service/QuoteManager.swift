//
//  QuoteViewModel.swift
//  Joke
//
//  Created by Anastasiya on 01.08.2024.
//

import Foundation
import RealmSwift

class QuoteManager {
    
    init(){
        let config = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func addQuote (quote: Quote) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(QuoteRealm(quote: quote))
        }
    }
    
    static func listQuote() -> [QuoteRealm] {
        let realm = try! Realm()
        
        let quotesRealm = realm.objects(QuoteRealm.self)
        return quotesRealm.map({ $0 })
    }
    
    static func getCategorys() -> [String] {
        let realm = try! Realm()
        
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
        let realm = try! Realm()
        
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
