//
//  Portfolios.swift
//  portfolio
//
//  Created by Tunay Toksöz on 10.03.2023.
//

import Foundation

struct portfolio : Codable, Hashable {
    var name : String
    var value : Double
    var createdTime : Date?
    var createdTimeString : String?
    var totalValue : Double?
}
