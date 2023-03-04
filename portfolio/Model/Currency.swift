//
//  currency.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation

// MARK: - Currency
struct Currency: Codable {
    let data: dataCurrency
}

// MARK: - dataCurrency
struct dataCurrency: Codable {
    let eur, gbp, rub, usd: Double

    enum CodingKeys: String, CodingKey {
        case eur = "EUR"
        case gbp = "GBP"
        case rub = "RUB"
        case usd = "USD"
    }
}
