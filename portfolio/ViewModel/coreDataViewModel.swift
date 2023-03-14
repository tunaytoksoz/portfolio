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
    private let networkServiceProtocol : NetworkServiceProtocol

    weak var cdOutput : cdViewModelOutput?
    
    private var baseUrl = "https://api.freecurrencyapi.com/v1/"
    
    init(cdServiceProtocol: CoreDataServiceProtocol, networkServiceProtocol: NetworkServiceProtocol, cdOutput: cdViewModelOutput? = nil) {
        self.cdServiceProtocol = cdServiceProtocol
        self.networkServiceProtocol = networkServiceProtocol
        self.cdOutput = cdOutput
    }
    
    var retBool = false
    var ret = 0.0
    func getCurrency(name : String) {
        
    }
    
    func saveObject(portfolio : portfolio, curr : Double) -> Bool{
        self.cdServiceProtocol.savePortfolio(portfolio: portfolio, curr: curr) { result in
            switch result {
            case .success(true):
                self.retBool = true
                var total = UserDefaults.standard.object(forKey: "totalValue") as! Double
                total += portfolio.value / curr
                self.cdServiceProtocol.saveDailyTable(totalValue: total )
            case.failure(let error):
                print(error.localizedDescription)
                self.retBool = false
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
                print(portfolio)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /*
     func getDailyPortfolio(){
         let today = Date()
         
         cdServiceProtocol.getPortfolioWithDayFilter(date: Date().formatted(date: .numeric, time: .omitted)) { result in
                 switch result{
                 case .success(let portfolios):
                     print(portfolios.first?.totalValue)
                     print(portfolios)
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
             }
     }
     **/
}
