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
    func updateCurrencyLabels(keys : [[String]], values : [[Double]], currencies : [String:Double] , isSucces: Bool)
    func fillPortfolio(collectionArray : [collectionPortfolio])
    func updateCharts(view : UIView, type: chartType)
}


enum chartType {
    case pie
    case barDay
    case barWeek
    case barMonth
}
