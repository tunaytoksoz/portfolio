//
//  NetworkService.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func getData<T : Decodable>(url : URL, expecting : T.Type,  completion: @escaping (Result<T, RequestError>) -> Void)
    
}

class NetworkService : NetworkServiceProtocol{
    
    func getData<T : Decodable>(url : URL, expecting : T.Type,  completion: @escaping (Result<T, RequestError>) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let data = try JSONDecoder().decode(expecting.self, from: data)
                        completion(.success(data))
                    } catch {
                        completion(.failure(.jsonConversionFailure))
                    }
                } else {
                    completion(.failure(.invalidData))
                }
            } else {
                completion(.failure(.responseUnsuccessful))
            }
        }
        task.resume()
    }
}


enum RequestError: Error {
    
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
        
    }
}
