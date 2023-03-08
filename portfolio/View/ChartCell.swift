//
//  ChartCell.swift
//  portfolio
//
//  Created by Tunay Toksöz on 7.03.2023.
//

import UIKit
import Charts

class ChartCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "ChartCell"
    
    let pieChartView = PieChartView()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           addSubview(pieChartView)
           pieChartView.frame = bounds
           backgroundColor = .secondarySystemFill
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    func configure(portfolio : Portfolio) {
            
            let eur = PieChartDataEntry(value: portfolio.eur, label: "eur")
            let gbp = PieChartDataEntry(value: portfolio.gbp, label: "gbp")
            let rub = PieChartDataEntry(value: portfolio.rub, label: "rub")
            let usd = PieChartDataEntry(value: portfolio.usd, label: "usd")

            let entryPortfolios = [eur,gbp,rub,usd]
            let dataSet = PieChartDataSet(entries: entryPortfolios)
                
            
            let colors : [NSUIColor] = [.purple, .black, .blue, .red]
            dataSet.colors = colors

            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
        
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1
            formatter.percentSymbol = "%"
                
            let setFormatter = DefaultValueFormatter(formatter: formatter)
            data.setValueFormatter(setFormatter)
            
            pieChartView.legend.enabled = false
            pieChartView.drawHoleEnabled = false
            pieChartView.isUserInteractionEnabled = false
            pieChartView.rotationAngle = 0
       }
}
