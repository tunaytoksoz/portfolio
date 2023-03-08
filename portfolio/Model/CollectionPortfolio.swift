//
//  CollectionPortfolio.swift
//  portfolio
//
//  Created by Tunay Toksöz on 7.03.2023.
//

import Foundation

struct collectionPortfolio : Codable, Hashable {
    let name : String
    let price : Double
    let priceTL : Double
    let portfolio : [Portfolio]
}
