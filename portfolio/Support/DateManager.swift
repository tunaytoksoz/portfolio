//
//  dateManager.swift
//  portfolio
//
//  Created by Tunay Toksöz on 13.03.2023.
//

import Foundation

class DateManager {
    
    func getDate(dayNumber: Int) -> String{
        
            let calendar = Calendar.current
            var now = Date()
            var daysAgo = calendar.date(byAdding: .day, value: -dayNumber, to: now)!
        
            var nowStr = daysAgo.formatted(date: .numeric, time: .omitted)
            
        
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MM/dd/yyyy"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"

            
            
            if let date = dateFormatterGet.date(from: "\(nowStr)") {
                nowStr = dateFormatterPrint.string(from: date)
            } else {
                print("There was an error decoding the string")
            }
             
            return nowStr
    }
    
    func getToday() -> String{
        
            let calendar = Calendar.current
            var now = Date().formatted(date: .numeric, time: .omitted)
            
        
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MM/dd/yyyy"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"

            
            
            if let date = dateFormatterGet.date(from: "\(now)") {
                now = dateFormatterPrint.string(from: date)
            } else {
                print("There was an error decoding the string")
            }
             
            return now
    }
    
}
