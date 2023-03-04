//
//  CoreDataPortfolio.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation

// MARK: - Portfolio
struct Portfolio: Codable {
    var eur : Double
    var gbp : Double
    var rub : Double
    var usd : Double
    var createdDate : Date?
    var created : String?
}
