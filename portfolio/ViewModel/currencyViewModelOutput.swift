//
//  currencyViewModelOutput.swift
//  portfolio
//
//  Created by Tunay Toksöz on 1.03.2023.
//

import Foundation

protocol currencyViewModelOutput : AnyObject{
    func updateCurrencyLabels(eur : Double, gbp: Double, rub : Double, usd : Double, isSucces: Bool)
}
