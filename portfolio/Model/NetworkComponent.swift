//
//  NetworkComponent.swift
//  portfolio
//
//  Created by Tunay Toksöz on 8.04.2023.
//

import Foundation


struct NetworkComponent {
    var scheme : String
    var host : String
    var path : String
    var queryItems : [URLQueryItem]?
    
    var url : URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = queryItems
        
        return component.url
    }
}
