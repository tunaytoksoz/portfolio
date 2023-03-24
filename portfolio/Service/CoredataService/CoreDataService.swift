//
//  coreDataService.swift
//  portfolio
//
//  Created by Tunay Toksöz on 27.02.2023.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    func savePortfolio(portfolio : portfolio, curr : Double, completion: @escaping (Result<Bool,Error>) -> Void)
    func getPortfolio(completion:  @escaping (Result<[portfolio],Error>) -> Void)
    func saveDailyTable(totalValue : Double)
    func getDailyTable(completion:  @escaping (Result<[DailyPortfolios],Error>) -> Void)
    func getWeeklyTable(completion: @escaping (Result<[[DailyPortfolios]],Error>) -> Void)
    func getMonthlyTable(completion: @escaping (Result<[String : [Double]],Error>) -> Void)
    func checkDailyTableDate()
}

class CoreDataService : CoreDataServiceProtocol {
    
 
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func checkDailyTableDate(){
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let results = try context.fetch(fetchRequest)
            let lastDay = results.first?.day ?? Date()
            let lastDayValue = results.first?.totalValue ?? 0.0
            let calendar = Calendar.current
            let last = calendar.startOfDay(for: lastDay)
            
            let components = calendar.dateComponents([.day], from: last, to: Date())
            
            if let days = components.day{
                if days > 1 {
                    for i in 1...days {
                        let day = calendar.date(byAdding: .day, value: i, to: last)!
                        
                        do {
                            let dp = DailyPortfolio(context: context)
                            dp.totalValue = lastDayValue
                            dp.day = day
                            try context.save()
                        } catch {
                            
                        }
                    }
                }
            }
        } catch {
            
        }
    }
    
    func saveDailyTable(totalValue : Double){
        
        let context = appDelegate.persistentContainer.viewContext
        
        let today = Date().formatted(date: .numeric, time: .omitted)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let queryDate = dateFormatter.date(from: today)!
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: queryDate)
        let midnight = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "day >= %@ AND day < %@", queryDate as NSDate, midnight as NSDate)
        
        do {
            let response = try context.fetch(fetchRequest)
            if response.count > 0 {
                response.first?.totalValue = totalValue
                response.first?.day = Date()
                try context.save()
            } else {
                let dp = DailyPortfolio(context: context)
                dp.totalValue = totalValue
                dp.day = Date()
                try context.save()
            }
            UserDefaults.standard.set(Date(), forKey: "totalValueLastChange")
        } catch {
            
        }
    }
    
    func fakeDataGenerator(){
        let context = appDelegate.persistentContainer.viewContext
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        for i in 1...100 {
            let firstDay = calendar.date(byAdding: .day, value: -i, to: today)!
            
            do {
                let dp = DailyPortfolio(context: context)
                dp.totalValue = Double.random(in: 3000..<30000)
                dp.day = firstDay
                try context.save()
            } catch {
                
            }
        }
    }
    
    
    func savePortfolio(portfolio : portfolio, curr : Double, completion: @escaping (Result<Bool,Error>) -> Void){
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let total = UserDefaults.standard.object(forKey: portfolio.name) as? Double{
            let port = Portfolio(context: context)
            port.name = portfolio.name
            port.value = portfolio.value
            port.createdTime = Date()
            port.createdTimeStr = Date().formatted(date: .numeric, time: .standard)
            port.totalValue = total + portfolio.value
        } else {
            let port = Portfolio(context: context)
            port.name = portfolio.name
            port.value = portfolio.value
            port.createdTime = Date()
            port.createdTimeStr = Date().formatted(date: .numeric, time: .standard)
            port.totalValue = portfolio.value
        }
        
        do {
            try context.save()
            completion(.success(true))
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func getPortfolio(completion:  @escaping (Result<[portfolio],Error>) -> Void){
        var portArray : [portfolio] = [portfolio]()
        var nameTotals : [String : Double] = [:]
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        
        do {
            let portfolios = try context.fetch(fetchRequest)
            
            for port in portfolios {
                if let name = port.name, let amount = port.value as? Double {
                           if let currentTotal = nameTotals[name] {
                               nameTotals[name] = currentTotal + amount
                           } else {
                               nameTotals[name] = amount
                           }
                       }
            }
            
            for (name, total) in nameTotals {
                portArray.append(portfolio(name: name, value: total))
                UserDefaults.standard.setValue(total, forKey: name)
            }
            UserDefaults.standard.synchronize()
           
            completion(.success(portArray))
            
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func getDailyTable(completion:  @escaping (Result<[DailyPortfolios],Error>) -> Void){
        checkDailyTableDate()
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        
        var dailyTotals : [DailyPortfolios] = [DailyPortfolios]()
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let firstDay = calendar.date(byAdding: .day, value: -6, to: today)!
        
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "day >= %@", firstDay as NSDate)
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for res in results {
                dailyTotals.append(DailyPortfolios(totalValue: res.totalValue, day: res.day))
            }
            completion(.success(dailyTotals))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getWeeklyTable(completion: @escaping (Result<[[DailyPortfolios]],Error>) -> Void){
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        var weeklyTotals : [DailyPortfolios] = [DailyPortfolios]()
        
        let calendar = Calendar.current
        
        let weekDay = calendar.component(.weekday, from: .now)
        
        
        let lastDayofWeek = calendar.date(byAdding: .day, value: -weekDay, to: .now)!
        let firstDayofWeeks = calendar.date(byAdding: .weekOfMonth, value: -4, to: lastDayofWeek)!
        
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "day > %@ AND day < %@", firstDayofWeeks as NSDate, lastDayofWeek as NSDate)
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for res in results {
                weeklyTotals.append(DailyPortfolios(totalValue: res.totalValue, day: res.day))
            }
            let weeks = grouppedWeek(array: weeklyTotals)
            completion(.success(weeks))
        } catch{
            completion(.failure(error))
        }
        
    }
    
    func grouppedWeek(array : [DailyPortfolios]) -> [[DailyPortfolios]]{
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
    
    func getMonthlyTable(completion: @escaping (Result<[String : [Double]],Error>) -> Void){
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        var monthlyTable : [DailyPortfolios] = [DailyPortfolios]()
        
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let portfolios = try context.fetch(fetchRequest)
            
            for port in portfolios {
                monthlyTable.append(DailyPortfolios(totalValue: port.totalValue, day: port.day))
            }
            let months = grouppedMonth(array: monthlyTable)
            completion(.success(months))
        } catch{
            completion(.failure(error))
        }
    }
    
    func grouppedMonth(array : [DailyPortfolios]) -> [String : [Double]] {
        var months = [String : [Double]]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
       
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
