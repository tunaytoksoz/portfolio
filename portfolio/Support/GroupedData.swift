//
//  groupedData.swift
//  portfolio
//
//  Created by Tunay Toksöz on 29.03.2023.
//

import Foundation

protocol GroupedDataProtocol {
    func groupedKeys(array : [String]) -> [[String]]
    func groupedValues(array : [Double]) -> [[Double]]
    func groupedWeek(array : [DailyPortfolios]) -> [[DailyPortfolios]]
    func groupedMonth(array : [DailyPortfolios]) -> [String : [Double]]
}

class GroupedData : GroupedDataProtocol {
    
    func groupedKeys(array : [String]) -> [[String]] {
        var groupedArray = [[String]]()
        for i in stride(from: 0, to: array.count, by: 4) {
            var group = [String]()
            for j in i..<(i + 4) {
                if j < array.count {
                    group.append(array[j])
                }
            }
            groupedArray.append(group)
        }
        return groupedArray
    }
    
    func groupedValues(array : [Double]) -> [[Double]] {
        var groupedArray = [[Double]]()
        for i in stride(from: 0, to: array.count, by: 4) {
            var group = [Double]()
            for j in i..<(i + 4) {
                if j < array.count {
                    group.append(array[j])
                }
            }
            groupedArray.append(group)
        }
        return groupedArray
    }
    
    func groupedWeek(array : [DailyPortfolios]) -> [[DailyPortfolios]]{
        var weeks = [[DailyPortfolios]]()
        
        for index in stride(from: 0, to: array.count, by: 7){
            var subWeek = [DailyPortfolios]()
            for j in index..<(index + 7) {
                if j < array.count {
                    subWeek.append(array[j])
                }
            }
            weeks.append(subWeek)
        }
        return weeks
    }
    
    func groupedMonth(array : [DailyPortfolios]) -> [String : [Double]] {
        var months = [String : [Double]]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-yyyy"
       
        for arr in array {
            if let arrDay = arr.day {
                let monthString = dateFormatter.string(from: arrDay)
                if var month = months[monthString]{
                    months[monthString]?.append(arr.totalValue)
                } else {
                    months[monthString] = [arr.totalValue]
                }
            }
        }
        
        return months
    }
}
