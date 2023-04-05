//
//  NetworkService.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func getData(url : URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkService : NetworkServiceProtocol{
    
    func getData(url : URL, completion: @escaping (Result<Data, Error>) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

 enum FreeCurrencyApi : String {
     
     case scheme = "https"
     case host = "api.freecurrencyapi.com"
     case path = "/v1/latest"
     case apikeyName = "apikey"
     case apikey = "iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH"
     case queryName = "currencies"
     case query = "EUR,USD,GBP,RUB,JPY,CAD,PHP,PLN"
     case baseCurrencyName = "base_currency"
     case baseCurrency = "TRY"
     
 }
