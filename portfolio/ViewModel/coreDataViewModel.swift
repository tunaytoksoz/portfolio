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
    
    init(cdServiceProtocol: CoreDataServiceProtocol) {
        self.cdServiceProtocol = cdServiceProtocol
    }
    
    var eur = PieChartDataEntry(value: 0)
    var gbp = PieChartDataEntry(value: 0)
    var rub = PieChartDataEntry(value: 0)
    var usd = PieChartDataEntry(value: 0)
    
    private var entryPortfolios = [PieChartDataEntry]()
    
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
                self.cdOutput?.updatePortfolioLabels(eur: 0, gbp: 0, rub: 0, usd: 0, isSucces: false)
            }
        }
    }
    
    func updateChart(pieChart : PieChartView){
        
        getPortfolioPercent()
        
        entryPortfolios = [eur,gbp,rub,usd]
        
        self.eur.label = "eur"
        self.gbp.label = "gbp"
        self.rub.label = "rub"
        self.usd.label = "usd"
        
        let charDataSet = PieChartDataSet(entries: entryPortfolios)
        let chartData = PieChartData(dataSet: charDataSet)
        pieChart.data = chartData
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1
        formatter.percentSymbol = "%"
        
        let setFormatter = DefaultValueFormatter(formatter: formatter)
        chartData.setValueFormatter(setFormatter)
    
        let colors : [NSUIColor] = [.purple, .black, .blue, .red]
        charDataSet.colors = colors
    }
    
    func getPortfolioPercent(){
        cdServiceProtocol.getPortfolio { result in
            switch result{
            case .success(let portfolio):
                self.calculatePercent(eur: portfolio.eur, gbp: portfolio.gbp, rub: portfolio.rub, usd: portfolio.usd)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func calculatePercent(eur : Double,gbp : Double ,rub : Double,usd : Double) {
        let total = eur+gbp+rub+usd
        
        self.eur.value = eur * 100 / total
        self.gbp.value = gbp * 100 / total
        self.rub.value = rub * 100 / total
        self.usd.value = usd * 100 / total
    }
}
