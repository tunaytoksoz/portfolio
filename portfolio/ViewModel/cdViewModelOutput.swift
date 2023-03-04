//
//  cdViewModelOutput.swift
//  portfolio
//
//  Created by Tunay Toksöz on 1.03.2023.
//

import Foundation

protocol cdViewModelOutput : AnyObject {
    func updatePortfolioLabels(eur : Double, gbp : Double, rub : Double, usd : Double, isSucces : Bool)
}
