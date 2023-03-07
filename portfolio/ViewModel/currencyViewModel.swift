//
//  currencyViewModel.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation
import Charts

class currencyViewModel {
    
    private let networkService : NetworkServiceProtocol
    private let cdService : CoreDataServiceProtocol
    
    weak var output : currencyViewModelOutput?
    
    private var currenciesArray : [(eur : Double, gbp : Double, rub : Double, usd : Double)] = []

    
    init(networkService: NetworkServiceProtocol, cdService: CoreDataServiceProtocol, output: currencyViewModelOutput? = nil) {
        self.networkService = networkService
        self.cdService = cdService
        self.output = output
    }
    
    var eur : Double = 0.0
    var gbp : Double = 0.0
    var rub : Double = 0.0
    var usd : Double = 0.0
    
    private var currencyData : Currency?
    
    let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=iMsPqn3Rhbamaq9BxTP0Wh6g7ENnwPd9Khxl1hSH&currencies=EUR%2CUSD%2CGBP%2CRUB&base_currency=TRY")
    
    func getCurrencyData() {
        
        networkService.getData(url: url!) { result in
            switch result{
            case .success(let data):
                do {
                    let currency = try JSONDecoder().decode(Currency.self, from: data)
                    self.output?.updateCurrencyLabels(eur: currency.data.eur, gbp: currency.data.gbp, rub: currency.data.rub, usd: currency.data.usd, isSucces: true)
                } catch {
                    self.output?.updateCurrencyLabels(eur: 0, gbp: 0, rub: 0, usd: 0, isSucces: false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.output?.updateCurrencyLabels(eur: 0, gbp: 0, rub: 0, usd: 0, isSucces: false)
            }
        }
    }

    func convertPortfolio(){
        
        networkService.getData(url: url!) { result in
            switch result{
            case .success(let data):
                do {
                    let currency = try JSONDecoder().decode(Currency.self, from: data)
                    self.currenciesArray.append((currency.data.eur, currency.data.gbp, currency.data.rub, currency.data.usd))
                    self.cdService.getPortfolio { result in
                        switch result{
                        case .success(let portfolio):
                            self.output?.convertTL(eur: portfolio.eur / self.currenciesArray[0].eur,
                                                   gbp: portfolio.gbp / self.currenciesArray[0].gbp,
                                                   rub: portfolio.rub / self.currenciesArray[0].rub,
                                                   usd: portfolio.usd / self.currenciesArray[0].usd)
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.output?.convertTL(eur: 0, gbp: 0, rub: 0, usd: 0)
                        }
                    }
                } catch {
                    self.currenciesArray.append((1,1,1,1))
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.output?.updateCurrencyLabels(eur: 0, gbp: 0, rub: 0, usd: 0, isSucces: false)
            }
        }
    }
    
    func updateChart(){
        
        networkService.getData(url: url!) { result in
            switch result {
            case .success(let data):
                do {
                    let currency = try JSONDecoder().decode(Currency.self, from: data)
                    self.calculatePercent(eur: 1 / currency.data.eur, gbp: 1 / currency.data.gbp , rub: 1 / currency.data.rub, usd: 1 / currency.data.usd)
                } catch {
                    self.calculatePercent(eur: 1, gbp: 1, rub: 1, usd: 1)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func calculatePercent(eur : Double,gbp : Double ,rub : Double,usd : Double) {
        var total = 0.0
        
        cdService.getPortfolio { result in
                    switch result {
                    case .success(let portfolio):
                        self.eur = portfolio.eur * eur
                        self.gbp = portfolio.gbp * gbp
                        self.rub = portfolio.rub * rub
                        self.usd = portfolio.usd * usd
                        
                        total = self.eur + self.gbp + self.rub + self.usd
                        
                        if total > 0 {
                            self.eur = self.eur  * 100 / total
                            self.gbp = self.gbp  * 100 / total
                            self.rub = self.rub  * 100 / total
                            self.usd = self.usd  * 100 / total
                        } else {
                            self.eur = 0
                            self.gbp = 0
                            self.rub = 0
                            self.usd = 0
                        }
                        
                        self.output?.updatePiechart(eur: self.eur, gbp: self.gbp, rub: self.rub, usd: self.usd)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        
    }
}


/**
 func getPortfolioPercent(){
     networkService.getData(url: url!) { result in
         switch result {
         case .success(let data):
             do {
                 let currency = try JSONDecoder().decode(Currency.self, from: data)
                 self.currenciesArray.append((currency.data.eur, currency.data.gbp, currency.data.rub, currency.data.usd))
                 print("sdfs")
                 self.cdService.getPortfolio { result in
                     switch result{
                     case .success(let portfolio):
                         self.calculatePercent(eur: portfolio.eur / self.currenciesArray[0].eur,
                                          gbp:  portfolio.gbp / self.currenciesArray[0].gbp,
                                          rub: portfolio.rub / self.currenciesArray[0].rub,
                                          usd: portfolio.usd / self.currenciesArray[0].usd)
                         
                     case .failure(let error):
                         print(error.localizedDescription)
                         self.eur.value = 0
                         self.gbp.value = 0
                         self.rub.value = 0
                         self.usd.value = 0
                         
                     }
                 }
             } catch {
                 self.currenciesArray.append((0,0,0,0))
                 self.currenciesArray.removeAll()
             }
         case .failure(let error):
             print(error.localizedDescription)
         }
     }
 }
 
 func calculatePercent(eur : Double,gbp : Double ,rub : Double,usd : Double) {
     let total = eur+gbp+rub+usd
     
     if total > 0 {
         self.eur.value = eur * 100 / total
         self.gbp.value = gbp * 100 / total
         self.rub.value = rub * 100 / total
         self.usd.value = usd * 100 / total
         print("sfdklsd")
     } else {
         self.eur.value = 0
         self.gbp.value = 0
         self.rub.value = 0
         self.usd.value = 0
     }
 }
 */
