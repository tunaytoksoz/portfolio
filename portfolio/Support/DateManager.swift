//
//  dateManager.swift
//  portfolio
//
//  Created by Tunay Toksöz on 13.03.2023.
//

import Foundation
import Charts

class DateManager {
    
}


extension Date{
    
        var startOfDay: Date {
                return Calendar.current.startOfDay(for: self)
        }

        var endOfDay: Date {
                var components = DateComponents()
                components.day = 1
                components.second = -1
                return Calendar.current.date(byAdding: components, to: startOfDay)!
        }
        
        var startOfWeek: Date {
            Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
        }
        
        var endOfWeek: Date {
            var components = DateComponents()
            components.weekOfYear = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfWeek)!
        }
}
