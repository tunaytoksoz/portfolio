//
//  PortfolioViewControllerDelegate.swift
//  portfolio
//
//  Created by Tunay Toksöz on 8.04.2023.
//

import Foundation
import UIKit

protocol PortfolioViewControllerDelegate : AnyObject {
    func updateCurrencyLabels(keys : [[String]], values : [[Double]], currencies : Currency , isSucces: Bool)
    func fillPortfolio(collectionArray : [collectionPortfolio], isSucces: Bool)
    func updateTransactionsTable(porfolio : [Portfolios], isSucces : Bool)
    func updateCharts(view : UIView, type: chartType)
}

enum chartType {
    case pie
    case barDay
    case barWeek
    case barMonth
}
