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
