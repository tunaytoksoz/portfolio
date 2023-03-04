//
//  currencyViewModel.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation

class currencyViewModel {
    
    private let networkService : NetworkServiceProtocol
    
    weak var output : currencyViewModelOutput?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
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
                self.output?.updateCurrencyLabels(eur: 0, gbp: 0, rub: 0, usd: 0, isSucces: false)
            }
        }
    }
}
