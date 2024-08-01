//
//  Model.swift
//  Joke
//
//  Created by Anastasiya on 01.08.2024.
//

import Foundation
import RealmSwift

/*
 {"categories":[],
 "created_at":"2020-01-05 13:42:21.455187",
 "icon_url":"https://api.chucknorris.io/img/avatar/chuck-norris.png",
 "id":"T4aok2dnShmxsZ4JOHZJwg",
 "updated_at":"2020-01-05 13:42:21.455187",
 "url":"https://api.chucknorris.io/jokes/T4aok2dnShmxsZ4JOHZJwg",
 "value":"Chuck Norris taught Moses how to use a GPS"}
 */

struct Quote: Codable {
    let categories: [String]
    let createdAt: String
    let iconURL: String
    let id, updatedAt: String
    let url: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url, value
    }
}

class QuoteRealm: Object{
    
    @Persisted var categories: List<String>
    @Persisted var createdAt: String
    @Persisted var iconUrl: String
    @Persisted var id: String
    @Persisted var updatedAt: String
    @Persisted var url: String
    @Persisted var value: String
    
    init(quote: Quote){
        let list = List<String>()
        list.append(objectsIn: quote.categories)
        self.categories = list
        self.createdAt = quote.createdAt
        self.iconUrl = quote.iconURL
        self.id = quote.id
        self.updatedAt = quote.updatedAt
        self.url = quote.url
        self.value = quote.value
    }
    override init(){}
}
