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
    
    func saveObject(portfolio : portfolio) -> Bool{
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
                print(portfolio)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
