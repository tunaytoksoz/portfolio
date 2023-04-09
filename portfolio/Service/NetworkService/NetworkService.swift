//
//  NetworkService.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    //func getData(url : URL, completion: @escaping (Result<Data, Error>) -> Void)
    func getData<T : Decodable>(url : URL, expecting : T.Type,  completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService : NetworkServiceProtocol{
    
    func getData<T : Decodable>(url : URL, expecting : T.Type,  completion: @escaping (Result<T, Error>) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                do {
                    let data = try JSONDecoder().decode(expecting.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
