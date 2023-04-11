//
//  ChartGenerator.swift
//  portfolio
//
//  Created by Tunay Toksöz on 29.03.2023.
//

import Foundation
import UIKit
import Charts

protocol ChartGeneratorProtocol{
    func createPieChart(percentArray : [String : Double]) -> UIView
    func createDailyBarChart(values : [DailyPortfolios]) -> UIView
    func createWeeklyBarChart(values : [DailyPortfolios]) -> UIView
    func createMonthlyBarChart(data : [String : Double]) -> UIView
}


class ChartGenerator : ChartGeneratorProtocol {
    
    func createDailyBarChart(values: [DailyPortfolios]) -> UIView {
        
        let view = UIView()
        let chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        var entries = [BarChartDataEntry]()
        
        var days : [String] = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd"
        
        var arr : [Double] = [Double]()
        for (index, value) in values.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value.totalValue)
            entries.append(entry)
            days.append(dateFormatter.string(from: value.day!))
            arr.append(value.totalValue)
        }

        if arr.count > 0 {
            chartView.leftAxis.axisMaximum = arr.max()! * 1.5
        }
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.xAxis.labelPosition = .bottom
        chartView.fitBars = true
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.enabled = false
        
        let format = NumberFormatter()
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 0
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        
        let dataSet = BarChartDataSet(entries: entries, label: "Last Week")
        let data = BarChartData(dataSet: dataSet)
        chartView.data = data
        chartView.data?.setValueFormatter(formatter)
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chartView.frame = view.frame
        chartView.center = view.center
        chartView.isUserInteractionEnabled = false
        
        view.addSubview(chartView)
        
        return view
    }
    
    func createWeeklyBarChart(values: [DailyPortfolios]) -> UIView {
        let calendar = Calendar.current
        var days : [String] = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd"
        
        let view = UIView()
        let chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        var entries = [BarChartDataEntry]()
            
        for (index, value) in values.enumerated(){
                let entry = BarChartDataEntry(x: Double(index), y: value.totalValue)
                entries.append(entry)
                let weekFirstDay = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: value.day!).date
                days.append(dateFormatter.string(from: weekFirstDay!) + "\n" + dateFormatter.string(from: value.day!))
        }
            
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.xAxis.labelPosition = .bottom
        chartView.fitBars = true
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.enabled = false
        let format = NumberFormatter()
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 0
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        
        let dataSet = BarChartDataSet(entries: entries, label: "Last 4 Week")
        let data = BarChartData(dataSet: dataSet)
        chartView.data = data
        chartView.barData?.setValueFormatter(formatter)
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chartView.frame = view.frame
        chartView.center = view.center
        chartView.isUserInteractionEnabled = false
        
        view.addSubview(chartView)
            
        return view
    }
    
    func createMonthlyBarChart(data: [String : Double]) -> UIView {
        
        let view = UIView()
        let chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        var entries = [BarChartDataEntry]()
        var months = [String]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-yyyy"
        
        let result = data.sorted {
            dateFormatter.date(from: $0.0)! < dateFormatter.date(from: $1.0)!
        }
        
        for (index, value) in result.enumerated(){
            let entry = BarChartDataEntry(x: Double(index), y: value.value)
            entries.append(entry)
            months.append(value.key)
        }
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.labelPosition = .bottom
        chartView.fitBars = true
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.enabled = false
        
        let format = NumberFormatter()
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 0
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        
        let dataSet = BarChartDataSet(entries: entries, label: "Last \(months.count) month")
        let data = BarChartData(dataSet: dataSet)
        chartView.data = data
        chartView.barData?.setValueFormatter(formatter)
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chartView.frame = view.frame
        chartView.center = view.center
        chartView.isUserInteractionEnabled = false
        
        view.addSubview(chartView)
        
        return view
    }
    
    
    func createPieChart(percentArray: [String : Double]) -> UIView {
        
            let view = UIView()
            let pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))

            var entryPortfolios = [ChartDataEntry]()
            
            for array in percentArray{
                let entry = PieChartDataEntry(value: array.value, label: array.key)
                entryPortfolios.append(entry)
            }
 
            let dataSet = PieChartDataSet(entries: entryPortfolios, label: "Portföyüm")
            dataSet.colors = ChartColorTemplates.colorful()
            
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
        
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1
            formatter.percentSymbol = "%"
                
            let setFormatter = DefaultValueFormatter(formatter: formatter)
            data.setValueFormatter(setFormatter)
            
            pieChartView.legend.enabled = true
            pieChartView.drawHoleEnabled = false
            pieChartView.isUserInteractionEnabled = false
            pieChartView.rotationAngle = 0
            pieChartView.drawEntryLabelsEnabled = false
            pieChartView.animate(xAxisDuration: 1.3, yAxisDuration: 1.3)
            pieChartView.frame = view.frame
            pieChartView.center = view.center
            view.addSubview(pieChartView)
        
        return view
    }
    
}
