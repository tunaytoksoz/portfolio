//
//  currencyViewModelOutput.swift
//  portfolio
//
//  Created by Tunay Toksöz on 1.03.2023.
//

import Foundation
import Charts
import UIKit

protocol currencyViewModelOutput : AnyObject{
    func updateCurrencyLabels(keys : [[String]], values : [[Double]], isSucces: Bool)
    func fillPortfolio(collectionArray : [collectionPortfolio])
    func updatePiechart(view : UIView)
}
