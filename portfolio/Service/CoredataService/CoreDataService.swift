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
    func savePortfolio(portfolio : Portfolios, curr : Double, completion: @escaping (Result<Bool,Error>) -> Void)
    func getPortfolio(completion:  @escaping (Result<[Portfolios],Error>) -> Void)
    func saveDailyTable(totalValue : Double)
    func getLastWeekTable(completion:  @escaping (Result<[DailyPortfolios],Error>) -> Void)
    func getWeeklyTable(completion: @escaping (Result<[[DailyPortfolios]],Error>) -> Void)
    func getMonthlyTable(completion: @escaping (Result<[String : [Double]],Error>) -> Void)
    func getTransactions(completion:  @escaping (Result<[Portfolios],Error>) -> Void)
}

class CoreDataService : CoreDataServiceProtocol {
    
    private let groupedData : GroupedDataProtocol
    
    init(groupedData: GroupedDataProtocol) {
        self.groupedData = groupedData
    }

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
            
            let components = calendar.dateComponents([.day], from: last, to: Date().endOfDay)
            
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
        
        let startOfDay = Date().startOfDay
        let midnight = Date().endOfDay
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "day >= %@ AND day < %@", startOfDay as NSDate, midnight as NSDate)
        
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
    
        /**
         func fakeDataGenerator(){
             let context = appDelegate.persistentContainer.viewContext
             let calendar = Calendar.current
             let today = calendar.startOfDay(for: Date().endOfDay)
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
         */
    
    
    func savePortfolio(portfolio : Portfolios, curr : Double, completion: @escaping (Result<Bool,Error>) -> Void){
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let total = UserDefaults.standard.object(forKey: portfolio.name) as? Double{
            let port = Portfolio(context: context)
            port.name = portfolio.name
            port.value = portfolio.value
            port.createdTime = Date()
            port.createdTimeStr = Date().formatted(date: .numeric, time: .standard)
            port.totalValue = total + portfolio.value
            port.currency = 1 / curr
        } else {
            let port = Portfolio(context: context)
            port.name = portfolio.name
            port.value = portfolio.value
            port.createdTime = Date()
            port.createdTimeStr = Date().formatted(date: .numeric, time: .standard)
            port.totalValue = portfolio.value
            port.currency = 1 / curr
        }
        
        do {
            try context.save()
            completion(.success(true))
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func getPortfolio(completion:  @escaping (Result<[Portfolios],Error>) -> Void){
        var portArray : [Portfolios] = [Portfolios]()
        var nameTotals : [String : Double] = [:]
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        
        do {
            let portfolios = try context.fetch(fetchRequest)
            
            for port in portfolios {
                if let name = port.name, let amount = port.value as? Double  {
                           if let currentTotal = nameTotals[name] {
                               nameTotals[name] = currentTotal + amount
                           } else {
                               nameTotals[name] = amount
                           }
                       }
            }
            
            for (name, total) in nameTotals {
                portArray.append(Portfolios(name: name, value: total))
                UserDefaults.standard.setValue(total, forKey: name)
            }
            UserDefaults.standard.synchronize()
           
            completion(.success(portArray))
            
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func getTransactions(completion:  @escaping (Result<[Portfolios],Error>) -> Void){
        var portArray : [Portfolios] = [Portfolios]()
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        fetchRequest.fetchLimit = 10
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false)]
        
        do {
            let portfolios = try context.fetch(fetchRequest)
            
            for port in portfolios {
                portArray.append(Portfolios(name: port.name ?? "", value: port.value, createdTime: port.createdTime, createdTimeString: port.createdTimeStr, totalValue: port.totalValue, currency: port.currency))
            }
            
            completion(.success(portArray))
            
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    func getLastWeekTable(completion:  @escaping (Result<[DailyPortfolios],Error>) -> Void){
        
        checkDailyTableDate()
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<DailyPortfolio> = DailyPortfolio.fetchRequest()
        
        var dailyTotals : [DailyPortfolios] = [DailyPortfolios]()
        
        let calendar = Calendar.current
        let today = Date().startOfDay
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
        let lastDayofWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: Date().endOfWeek)!
        let firstDayofWeeksOneMonthAgo = calendar.date(byAdding: .weekOfMonth, value: -4, to: lastDayofWeek)!

        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "day > %@ AND day < %@", firstDayofWeeksOneMonthAgo as NSDate, lastDayofWeek as NSDate)
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for res in results {
                weeklyTotals.append(DailyPortfolios(totalValue: res.totalValue, day: res.day))
            }
            
            let weeks = self.groupedData.groupedWeek(array: weeklyTotals)
            completion(.success(weeks))
        } catch{
            completion(.failure(error))
        }
        
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
            let months = self.groupedData.groupedMonth(array: monthlyTable)
            completion(.success(months))
        } catch{
            completion(.failure(error))
        }
    }
}
