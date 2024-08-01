//
//  NetworkManager.swift
//  Joke
//
//  Created by Anastasiya on 01.08.2024.
//

import Foundation

struct NetworkManager{
    
    static let url = URL(string: "https://api.chucknorris.io/jokes/random")!
    
    static func getQuote(completion: @escaping (Result<Quote, Error>) -> Void){
        
        let task = URLSession.shared.dataTask(with: url){ data, response, error in

            guard let data else {
                return
            }
            do{
                let quote = try JSONDecoder().decode(Quote.self, from: data)
                completion(.success(quote))
            }catch{
                print("Ошибка")
            }
            
        }
        
        task.resume()
    }
}
