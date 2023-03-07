//
//  coreDataViewModel.swift
//  portfolio
//
//  Created by Tunay Toksöz on 28.02.2023.
//

import Foundation
import Charts

class coreDataViewModel {
    
    private let cdServiceProtocol : CoreDataServiceProtocol

    weak var cdOutput : cdViewModelOutput?
    
    init(cdServiceProtocol: CoreDataServiceProtocol, cdOutput: cdViewModelOutput? = nil) {
        self.cdServiceProtocol = cdServiceProtocol
        self.cdOutput = cdOutput
    }
    
    var retBool = false
    
    func saveObject(portfolio : Portfolio) -> Bool{
        cdServiceProtocol.savePortfolio(portfolio: portfolio) { result in
            switch result {
            case .success(true):
                self.retBool = true
            case .failure(let error):
                self.retBool = false
                print(error.localizedDescription)
            default:
                self.retBool = false
            }
        }
        return retBool
    }

    func getPortfolio() {
        cdServiceProtocol.getPortfolio { result in
            switch result{
            case .success(let portfolio):
                self.cdOutput?.updatePortfolioLabels(eur: portfolio.eur, gbp: portfolio.gbp, rub: portfolio.rub, usd: portfolio.usd, isSucces: true)
            case .failure(let error):
                print(error.localizedDescription)
                self.cdOutput?.updatePortfolioLabels(eur: 0, gbp: 0, rub: 0, usd: 0, isSucces: false)
            }
        }
    }
}
