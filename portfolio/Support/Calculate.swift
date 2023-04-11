//
//  Calculate.swift
//  portfolio
//
//  Created by Tunay Toksöz on 29.03.2023.
//

import Foundation

protocol CalculateProtocol {
    func calculatePercent(collectinArray : [collectionPortfolio] ) -> [String : Double]
    func calculateTL(portfolios : [Portfolios], currency : [String : Double]) -> [collectionPortfolio]
    func calculateAverageWeek(array : [[DailyPortfolios]]) -> [DailyPortfolios]
    func calculateMonthlyAverage(data : [String : [Double]]) -> [String : Double]
}

class Calculate : CalculateProtocol {
    
    func calculateTL(portfolios: [Portfolios], currency: [String : Double]) -> [collectionPortfolio] {
        var collectionArray : [collectionPortfolio] = [collectionPortfolio]()
        for port in portfolios{
            collectionArray.append(collectionPortfolio(name: port.name, price: port.value, priceTL: port.value / (currency[port.name] ?? 1)))
        }
        
        collectionArray.removeAll { $0.price == 0.0 }
        
        return collectionArray
    }
    
    
    func calculatePercent(collectinArray : [collectionPortfolio] ) -> [String : Double] {
        var total = 0.0
        var percentArray : [String : Double] = [:]
        for array in collectinArray {
            total += array.priceTL
        }
        for array in collectinArray {
            percentArray[array.name] = array.priceTL * 100 / total
        }
        return percentArray
    }
    
    func calculateAverageWeek(array : [[DailyPortfolios]]) -> [DailyPortfolios] {
        var weekArray : [DailyPortfolios] = [DailyPortfolios]()
        
        for subArray in array{
            var total = 0.0
            for i in subArray{
                total += i.totalValue
            }
            total = total / Double(subArray.count)
            weekArray.append(DailyPortfolios(totalValue: total, day: subArray.last?.day))
        }
        return weekArray
    }
    
    func calculateMonthlyAverage(data : [String : [Double]]) -> [String : Double] {
        var averages = [String : Double]()
        
        for (mont, values) in data {
            let total =  values.reduce(0, +)
            let count = values.count
            
            let avg = Double(total) / Double(count)
            averages[mont] = avg
        }
        
        return averages
    }
    
}
