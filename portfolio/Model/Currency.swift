//
//  currency.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation

// MARK: - Currency
struct Currency : Codable{
        let data: [String : Double]
}

struct CurrencyWithHistory : Codable {
    let data : [String : [String : Double]]
}
