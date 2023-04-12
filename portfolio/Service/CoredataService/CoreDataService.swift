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
    func saveDailyTable(totalValue : Double)
    func savePortfolio(portfolio : Portfolios, curr : Double) -> Bool
    func getPortfolio(fetchRequest : NSFetchRequest<Portfolio> ,completion:  @escaping (Result<[Portfolios],Error>) -> Void)
    func getDailyPorfolios(fetchRequest : NSFetchRequest<DailyPortfolio> ,completion: @escaping (Result<[DailyPortfolios],Error>) -> Void)
}

class CoreDataService : CoreDataServiceProtocol {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func savePortfolio(portfolio : Portfolios, curr : Double) -> Bool{
        
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
            return true
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
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
    
    
    
    func getPortfolio(fetchRequest : NSFetchRequest<Portfolio>, completion: @escaping (Result<[Portfolios], Error>) -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        var portArray : [Portfolios] = [Portfolios]()
        do {
            let portfolios = try context.fetch(fetchRequest)
            
            for portfolio in portfolios {
                portArray.append(Portfolios(name: portfolio.name ?? "Unknown", value: portfolio.value, createdTime: portfolio.createdTime, createdTimeString: portfolio.createdTimeStr, totalValue: portfolio.totalValue, currency: portfolio.currency))
            }
            completion(.success(portArray))
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
    
    func getDailyPorfolios(fetchRequest: NSFetchRequest<DailyPortfolio>, completion: @escaping (Result<[DailyPortfolios],Error>) -> Void) {
        checkDailyTableDate()
        let context = appDelegate.persistentContainer.viewContext
        var dailyTotals : [DailyPortfolios] = [DailyPortfolios]()
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results {
                dailyTotals.append(DailyPortfolios(totalValue: result.totalValue, day: result.day))
            }
            completion(.success(dailyTotals))
        } catch{
            completion(.failure(error))
        }
    }
    
        /*
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
}
